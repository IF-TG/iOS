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
  
  var posts: [Post] = []
  
  var postThumbnails: [[Data]] = []
  
  var isPaging: Bool = false
  
  var isRefreshing: Bool = false
  
  var isPostFiltering: Bool = false
    
  /// 서버에서 페이징이 실패하기 전까지 다음 페이지들이 있는것으로 간주합니다.
  /// 다음 페이지 요청 실패할 경우 hasMorePages를 false로 바꾸어야 합니다.
  var hasMorePages = true
  
  private let queueForLocking = DispatchQueue(
    label: "com.yeoga.app.feedPosVM.queue",
    attributes: .concurrent
  )
  
  private var category: PostCategory
  
  /// 사용자가 선택한 카테고리는 요청이 완료되야만 category에 사용자가 요청했던 데이터를 보여줌과
  ///   동시에 category 사용자가 선택한 카테고리로  업데이트 해야합니다.
  private lazy var userSelectedCategory: PostCategory = category
  
  private let postFetchUseCase: PostFetchUseCase
  
  private let nextPageLoadingStartSubject = PassthroughSubject<Void, Never>()
  
  private let postFilterLoadingStartSubject = PassthroughSubject<Void, Never>()
  
  private let viewDidLoadHandler = PassthroughSubject<Void, Never>()
  
  // MARK: - Lifecycle
  init(postCategory: PostCategory, postFetchUseCase: PostFetchUseCase) {
    self.postFetchUseCase = postFetchUseCase
    self.category = postCategory
  }
}

// MARK: - FeedPostViewModelable
extension FeedPostViewModel: FeedPostViewModelable {
  func transform(_ input: Input) -> AnyPublisher<State, Never> {
    return Publishers.MergeMany([
      postShareSubjectStream(input),
      postBlockSubjectStream(input),
      postFilterLoadingStartSubjectStream(),
      notifiedOrderFilterRequestStream(input),
      notifiedMainThemeFilterRequestStream(input),
      viewDidLoadStream(input),
      viewDidLoadHandlerStream(),
      nextPageStream(input),
      feedRefreshStream(input),
      nextPageLoadingStartSubjectStream(),
      specificPostTappedStream(input)]
    ).eraseToAnyPublisher()
  }
}

// MARK: - Private Helpers
private extension FeedPostViewModel {
  // TODO: - 포스트 아이디 Int로 변환해야함.
  func postShareSubjectStream(_ input: Input) -> Output {
    return input.postShareSubject.map { [weak self] indexPath -> State in
      guard let item = self?.postItem(at: indexPath.item) else {
        return .unexpectedError(description: "앱 내부 서비스 에러가 발생됬습니다.")
      }
      let title = item.header.contentInfo.title
      return .share(title, Int(item.postId)!)
    }.eraseToAnyPublisher()
  }
  
  func postBlockSubjectStream(_ input: Input) -> Output {
    return input.postBlockSubject.map { [weak self] blockedPostId -> State in
      let blockedPostIdIndex = self?.posts.firstIndex(where: {
        Int32($0.detail.postID)! == blockedPostId
      })
      guard let blockedPostIdIndex else {
        return .unexpectedError(description: "앱 내부 동작 에러가 발생됬습니다. 차단된 포스트 아이디가 식별 불가능합니다.")
      }
      self?.posts.remove(at: blockedPostIdIndex)
      return .deleteBlockedPost(IndexPath(item: blockedPostIdIndex, section: PostViewSection.post.rawValue))
    }.eraseToAnyPublisher()
  }
  
  func postFilterLoadingStartSubjectStream() -> Output {
    postFilterLoadingStartSubject.map { [weak self] _ -> State in
      self?.isPostFiltering = true
      self?.queueForLocking.async(flags: .barrier) {
        self?.hasMorePages = true
      }
      return .networking
    }.eraseToAnyPublisher()
  }
  
  func notifiedOrderFilterRequestStream(_ input: Input) -> Output {
    return input.notifiedOrderFilterRequest
      .flatMap { [weak self] selectedOrderType in
        guard let mainTheme = self?.category.mainTheme else {
          return Just(State.unexpectedError(description: "앱 내부 동작 에러가 발생됬습니다"))
            .eraseToAnyPublisher()
        }
        self?.userSelectedCategory = PostCategory(mainTheme: mainTheme, orderBy: selectedOrderType)
        self?.postFilterLoadingStartSubject.send()
        return self?.fetchPosts()
          .map { [weak self] _ -> State in
            if self?.hasMorePages == false {
              return .pagination(.noMorePage)
            }
            return .postFilterLoaded
          }.catch { error in
            return Just(State.unexpectedError(description: error.localizedDescription))
          }.eraseToAnyPublisher() ?? Just(
            State.unexpectedError(description: "앱 내부 동작 에러가 발생됬습니다.")
          ).eraseToAnyPublisher()
      }.eraseToAnyPublisher()
  }
  
  func notifiedMainThemeFilterRequestStream(_ input: Input) -> Output {
    return input.notifiedMainThemeFilterRequest
      .flatMap { [weak self] selectedMainTheme in
        guard let orderType = self?.category.orderBy else {
          return Just(State.unexpectedError(description: "앱 내부 동작 에러가 발생됬습니다."))
            .eraseToAnyPublisher()
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
          return Just(State.none).eraseToAnyPublisher()
        }
        self?.postFilterLoadingStartSubject.send()
        return self?.fetchPosts()
          .map { [weak self] _ -> State in
            if self?.hasMorePages == false {
              return .pagination(.noMorePage)
            }
            return .postFilterLoaded
          }.catch { error in
            return Just(State.unexpectedError(description: error.localizedDescription))
          }.eraseToAnyPublisher() ?? Just(
            State.unexpectedError(description: "앱 내부 동작 에러가 발생됬습니다.")
          ).eraseToAnyPublisher()
      }.eraseToAnyPublisher()
  }
  
  func viewDidLoadStream(_ input: Input) -> Output {
    return input.viewDidLoad.map { [weak self] _ in
      DispatchQueue.global(qos: .userInitiated).async {
        self?.viewDidLoadHandler.send()
      }
      return .networking
    }.eraseToAnyPublisher()
  }
  
  func viewDidLoadHandlerStream() -> Output {
    return viewDidLoadHandler
      .flatMap { [weak self] _ in
        return self?.fetchPosts()
          .map { _ in
            State.viewDidLoad
          }.catch { error in
            return Just(State.unexpectedError(description: error.localizedDescription))
          }.eraseToAnyPublisher() ?? Just(
            State.unexpectedError(description: "앱 동작 에러가 발생됬습니다.")
          ).eraseToAnyPublisher()
      }.eraseToAnyPublisher()
  }
  
  func nextPageStream(_ input: Input) -> Output {
    return input.nextPage
      .flatMap { [weak self] _ -> Output in
        if let hasMorePages = self?.hasMorePages, !hasMorePages {
          return Just(State.pagination(.noMorePage)).eraseToAnyPublisher()
        }
        self?.isPaging = true
        self?.nextPageLoadingStartSubject.send()
        return self?.fetchPosts()
          .map { [weak self] _ -> State in
            if self?.hasMorePages == false {
              self?.isPaging = false
              return .pagination(.noMorePage)
            }
            return .pagination(.nextPage(reloadCompletion: {
              self?.isPaging = false
            }))
          }.catch { error in
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
    nextPageLoadingStartSubject
      .receive(on: DispatchQueue.main)
      .map { _ -> State in
        return .pagination(.loadingNextPage)
      }.eraseToAnyPublisher()
  }
  
  func specificPostTappedStream(_ input: Input) -> Output {
    return input.specificPostTapped
      .map { [weak self] index -> State in
        guard let post = self?.posts[index] else {
          return .unexpectedError(description: ReferenceError.invalidReference.localizedDescription)
        }
        return .detailPostShow(post: post)
      }.eraseToAnyPublisher()
  }
  
  func appendPosts(_ postPages: PostsPage) {
    posts += postPages.posts
  }
  
  func removeAllPage() {
    queueForLocking.async(flags: .barrier) { [weak self] in
      self?.currentPage = 0
      self?.posts.removeAll()
      self?.postThumbnails.removeAll()
      self?.hasMorePages = true
    }
  }
}

// MARK: - PostDataSource
extension FeedPostViewModel {
  func fetchPosts() -> AnyPublisher<Void, any Error> {
    let postFetchRequestValue = PostFetchRequestValue(
      page: nextPage,
      perPage: perPage,
      category: userSelectedCategory)
    return postFetchUseCase.fetchFilteredPosts(with: postFetchRequestValue)
      .map { [weak self] postsPage in
        if self?.isRefreshing == true || self?.isPostFiltering == true {
          self?.removeAllPage()
          self?.isRefreshing = false
          self?.isPostFiltering = false
        }
        if let userSelectedCategory = self?.userSelectedCategory {
          self?.category = userSelectedCategory
        }
        self?.postThumbnails.append(contentsOf: postsPage.thumbnails.map { $0.postImageDataList })
        self?.currentPage += 1
        self?.appendPosts(postsPage)
      }
      .catch { [weak self] error -> AnyPublisher<Void, any Error> in
        if error.isNoMorePage {
          self?.queueForLocking.async(flags: .barrier) {
            self?.hasMorePages = false
          }
          return Just(()).setFailureType(to: (any Error).self).eraseToAnyPublisher()
        }
        return Fail(error: error).eraseToAnyPublisher()
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
    return PostThumbnailCountValue(postItem(at: index).content.thumbnailImageDataList.count)
  }
  
  func postItem(at index: Int) -> PostInfo {
    let post = posts[index]
    let postInfo = PostMapper.toPostInfo(post, thumbnails: postThumbnails[index])
    return postInfo
  }
}
