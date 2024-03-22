//
//  FeedPostViewModel.swift
//  travelPlan
//
//  Created by 양승현 on 10/23/23.
//

import Foundation
import Combine

class FeedPostViewModel: PostViewModel {
  // MARK: - Properties
  var currentPage: Int32 = 0
  
  var nextPage: Int32 { hasMorePages ? currentPage + 1 : currentPage }
  
  let perPage: Int32 = 5
  
  var posts: [PostInfo] = []
  
  var postDetailedThumbnails: [[String]] = []
  
  var isPaging: Bool = false
  
  var isRefreshing: Bool = false
  
  // FIXME: - 서버한테 전체 개수 요청했습니다. 추후에 responseDTO랑 전부 바꿔서 여기에 값 넣어야 합니다.
  var totalPostsCount: Int32 = 0
  
  var hasMorePages: Bool {
    let totalPageCount = totalPostsCount/perPage
    return currentPage < totalPageCount
  }
  
  private var category: PostCategory
  
  /// 사용자가 선택한 카테고리는 요청이 완료되야만 category에 사용자가 요청했던 데이터를 보여줌과
  ///   동시에 category 사용자가 선택한 카테고리로  업데이트 해야합니다.
  private lazy var userSelectedCategory: PostCategory = category
  
  private let postUseCase: PostUseCase
  
  private let nextPageLoadingStartSubject = PassthroughSubject<Void, Never>()
  
  // MARK: - Lifecycle
  init(postCategory: PostCategory, postUseCase: PostUseCase) {
    self.postUseCase = postUseCase
    self.category = postCategory
  }
}

// MARK: - FeedPostViewModelable
extension FeedPostViewModel: FeedPostViewModelable {
  func transform(_ input: Input) -> AnyPublisher<State, Never> {
    return Publishers.MergeMany([
      notifiedOrderFilterRequestStream(input),
      notifiedMainThemeFilterRequestStream(input),
      viewDidLoadStream(input),
      nextPageStream(input),
      feedRefreshStream(input),
      nextPageLoadingStartSubjectStream()]
    ).eraseToAnyPublisher()
  }
}

// MARK: - Private Helpers
private extension FeedPostViewModel {
  func notifiedOrderFilterRequestStream(_ input: Input) -> Output {
    return input.notifiedOrderFilterRequest
      .map { [weak self] selectedOrderType in
        guard let mainTheme = self?.category.mainTheme else {
          return .unexpectedError(description: "앱 내부 동작 에러가 발생됬습니다")
        }
        self?.userSelectedCategory = PostCategory(mainTheme: mainTheme, orderBy: selectedOrderType)
        
        // TODO: - fetchPosts()호출요.
        return .none
      }.eraseToAnyPublisher()
  }
  
  func notifiedMainThemeFilterRequestStream(_ input: Input) -> Output {
    return input.notifiedMainThemeFilterRequest
      .map { [weak self] selectedMainTheme in
        guard let orderType = self?.category.orderBy else {
          return .unexpectedError(description: "앱 내부 동작 에러가 발생됬습니다.")
        }
        switch selectedMainTheme {
        case .partner(let partner):
          self?.userSelectedCategory = PostCategory(mainTheme: .partner(partner), orderBy: orderType)
        case .region(let region):
          self?.userSelectedCategory = PostCategory(mainTheme: .region(region), orderBy: orderType)
        case .season(let season):
          self?.userSelectedCategory = PostCategory(mainTheme: .season(season), orderBy: orderType)
        case .travelTheme(let theme):
          self?.userSelectedCategory = PostCategory(mainTheme: .travelTheme(theme), orderBy: orderType)
        default:
          return .none
        }
        // TODO: - 서버 호출해야함둥..
        
        return .none
      }.eraseToAnyPublisher()
  }
  
  func viewDidLoadStream(_ input: Input) -> Output {
    return input.viewDidLoad.flatMap { [weak self] _ in
      return self?.fetchPosts()
        .map { _ in State.viewDidLoad }
        .catch { error in
          return Just(State.unexpectedError(description: error.localizedDescription))
        }.eraseToAnyPublisher() ?? Just(
          State.unexpectedError(description: "앱 동작 에러가 발생됬습니다.")
        ).eraseToAnyPublisher()
    }.eraseToAnyPublisher()
  }
  
  func nextPageStream(_ input: Input) -> Output {
    return input.nextPage
      .flatMap { [weak self] in
        if let hasMorePages = self?.hasMorePages, !hasMorePages {
          return Just(State.noMorePage).eraseToAnyPublisher()
        }
        self?.isPaging = true
        self?.nextPageLoadingStartSubject.send()
        return self?.fetchPosts()
          .delay(for: .seconds(3), scheduler: DispatchQueue.global(qos: .background))
          .map { [weak self] _ -> State in
            return .nextPage {
              self?.isPaging = false
            }
          }.catch { error in
            // TODO: - 에러는 어떻게 처리할까? 경우를 따져보자. 레포, 유즈케이스 에러.... .. 레포가 다른데서도 사용된다면? 어느에러를 던져야지?
            return Just(State.unexpectedError(description: error.localizedDescription))
          }.eraseToAnyPublisher() ?? Just(
            State.unexpectedError(description: "앱 동작 에러가 발생됬습니다.")
          ).eraseToAnyPublisher()
      }
      .eraseToAnyPublisher()
  }
  
  func feedRefreshStream(_ input: Input) -> Output {
    return input.feedRefresh
      .flatMap { [weak self] in
        self?.isRefreshing = true
        return self?.fetchPosts()
          .map { _ -> State in
            return .refresh
          }.catch { error in
            return Just(State.unexpectedError(description: error.localizedDescription))
          }.eraseToAnyPublisher() ?? Just(
            State.unexpectedError(description: "앱 동작 중 에러가 발생됬습니다.")
          ).eraseToAnyPublisher()
      }.eraseToAnyPublisher()
  }
  
  func nextPageLoadingStartSubjectStream() -> Output {
    nextPageLoadingStartSubject.map { _ -> State in
      return .loadingNextPage
    }.eraseToAnyPublisher()
  }
  
  func appendPosts(_ postContainers: [PostContainer]) {
    let loadedPosts = postContainers.map { postContainer in
      return PostMapper.toPostInfo(postContainer.post, thumbnails: postContainer.thumbnails)
    }
    posts.append(contentsOf: loadedPosts)
  }
  
  func removeAllPage() {
    currentPage = 0
    posts.removeAll()
    postDetailedThumbnails.removeAll()
  }
}

// MARK: - PostDataSource
extension FeedPostViewModel {
  // 이를 호출할때 hasMorePages가 false라면 에러 던지자. 더이상 페이지 없다고
  func fetchPosts() -> AnyPublisher<[PostContainer], any Error> {
    let postFetchRequestValue = PostFetchRequestValue(
      page: nextPage,
      perPage: perPage,
      category: userSelectedCategory)
    return postUseCase.fetchPosts(with: postFetchRequestValue)
      .map { [weak self] postContainers in
        if self?.isRefreshing == true {
          self?.removeAllPage()
          self?.isRefreshing = false
        }
        if let userSelectedCategory = self?.userSelectedCategory {
          self?.category = userSelectedCategory
        }
        postContainers.forEach { postContainer in
          self?.postDetailedThumbnails.append(postContainer.post.detail.postImages.map { $0.imageUri })
        }
        self?.currentPage += 1
        self?.totalPostsCount = Int32(postContainers.first?.totalPosts ?? 1)
        self?.appendPosts(postContainers)
        return postContainers
      }
      .eraseToAnyPublisher()
  }
}

// MARK: - FeedPostViewAdapterDataSource
extension FeedPostViewModel: FeedPostViewAdapterDataSource {
  var headerItem: PostFilterOptions {
    return .travelMainTheme(category.mainTheme)
  }
  
  var numberOfItems: Int {
    posts.count
  }
  
  func numberOfThumbnailsInPost(at index: Int) -> PostThumbnailCountValue {
    return PostThumbnailCountValue(postItem(at: index).content.thumbnailURLs.count)
  }
  
  func postItem(at index: Int) -> PostInfo {
    return posts[index]
  }
}
