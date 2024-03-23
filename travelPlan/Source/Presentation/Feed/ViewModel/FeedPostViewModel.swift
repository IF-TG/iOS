//
//  FeedPostViewModel.swift
//  travelPlan
//
//  Created by 양승현 on 10/23/23.
//

import Foundation
import Combine

class FeedPostViewModel: PostViewModel {
  struct Input {
    let feedRefresh: PassthroughSubject<Void, Never> = .init()
    let nextPage: PassthroughSubject<Void, Never> = .init()
    let viewDidLoad: PassthroughSubject<Void, Never> = .init()
  }
  
  enum State {
    case viewDidLoad
    case refresh
    case nextPage(reloadCompletion: ()->Void)
    case loadingNextPage
    case unexpectedError(description: String)
    case noMorePage
    case none
  }
  
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
  
  private let category: PostCategory
  
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
      viewDidLoadStream(input),
      nextPageStream(input),
      feedRefreshStream(input),
      nextPageLoadingStartSubjectStream()]
    ).eraseToAnyPublisher()
  }
}

// MARK: - Private Helpers
private extension FeedPostViewModel {
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
    let category = PostCategory(
      mainTheme: category.mainTheme,
      orderBy: category.orderBy)
    let postFetchRequestValue = PostFetchRequestValue(
      page: nextPage,
      perPage: perPage,
      category: category)
    return postUseCase.fetchPosts(with: postFetchRequestValue)
      .map { [weak self] postContainers in
        if self?.isRefreshing == true {
          self?.removeAllPage()
          self?.isRefreshing = false
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
