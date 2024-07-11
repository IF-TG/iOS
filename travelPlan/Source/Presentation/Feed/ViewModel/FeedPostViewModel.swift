//
//  FeedPostViewModel.swift
//  travelPlan
//
//  Created by 양승현 on 10/23/23.
//

import Foundation
import Combine

final class FeedPostViewModel: PostViewModel, PostOptionNotificationBinder {
  // MARK: - Dependencies
  private let postFetchUseCase: PostFetchUseCase
  
  // MARK: - Properties
  private var hasEnteredPostDetailScene = false
  
  var currentPage: Int32 = 0
  
  var nextPage: Int32 { hasMorePages ? currentPage + 1 : currentPage }
  
  let perPage: Int32 = 5
  
  var isPaging: Bool = false
  
  var isRefreshing: Bool = false
  
  var isPostFiltering: Bool = false
    
  /// 서버에서 페이징이 실패하기 전까지 다음 페이지들이 있는것으로 간주합니다.
  /// 다음 페이지 요청 실패할 경우 hasMorePages를 false로 바꾸어야 합니다.
  var hasMorePages = true
  
  private let lock = NSLock()
  
  // MARK: - Data source Properties
  private var category: PostCategory
  
  var posts: [Post] = []
  
  var postThumbnails: [[Data]] = []
  
  /// 사용자가 선택한 카테고리는 요청이 완료되야만 category에 사용자가 요청했던 데이터를 보여줌과
  ///   동시에 category 사용자가 선택한 카테고리로  업데이트 해야합니다.
  private lazy var userSelectedCategory: PostCategory = category

  // MARK: - Combine Properties
  private let postFilterLoadingStartSubject = PassthroughSubject<Void, Never>()
  
  private let viewDidLoadHandler = PassthroughSubject<Void, Never>()
  
  private let postHasBlockedHandler = PassthroughSubject<PostIdentifier, Never>()
  
  private var subscriptions = Set<AnyCancellable>()
  
  private let postShareNotifierByPostOption = PassthroughSubject<PostShareElement, Never>()
  
  var postOptionNotificationSubscriptions = Set<AnyCancellable>()
  
  var userWantToSharePostNotifier = PassthroughSubject<PostShareElement, Never>()
  
  /// haspostBlocked notification으로부터 알림을 전달받습니다.
  var postHasBlockedNotifier = PassthroughSubject<PostBlockedElement?, Never>()
  
  var updatedPostCommentsNotifier = PassthroughSubject<UpdatedPostCommentsEntity, Never>()
  
  // MARK: - Lifecycle
  init(postCategory: PostCategory, postFetchUseCase: PostFetchUseCase) {
    self.postFetchUseCase = postFetchUseCase
    self.category = postCategory
    bind()
  }
}

// MARK: - FeedPostViewModelable
extension FeedPostViewModel: FeedPostViewModelable {
  func transform(_ input: Input) -> AnyPublisher<State, Never> {
    return Publishers.MergeMany([
      postShareNotifierByPostOptionSream(),
      postShareSubjectStream(input),
      postBlockSubjectStream(input),
      postFilterLoadingStartSubjectStream(),
      notifiedOrderFilterRequestStream(input),
      notifiedMainThemeFilterRequestStream(input),
      viewDidLoadStream(input),
      viewDidLoadHandlerStream(),
      isAvailableNextPageStream(input),
      fetchNextPageStream(input),
      feedRefreshStream(input),
      specificPostTappedStream(input),
      postHasBlockedHandlerStream(),
      updatedPostCommentsNotifierStream()]
    ).eraseToAnyPublisher()
  }
}

// MARK: - Private Stream Helpers
private extension FeedPostViewModel {
  func updatedPostCommentsNotifierStream() -> Output {
    return updatedPostCommentsNotifier.map { [weak self] updatedPostCommentsEntity -> State in
      /// 디퍼드 딥링킹에 의해 들어온 경우 피드 화면 특정 셀 ->포스트 상세화면으로 이동하지 않고 바로 포스트 상세화면으로 이동하기에 처리하지 않습니다.
      if updatedPostCommentsEntity.hasEnteredByDeferredDeepLink {
        return .none
      }
      
      /// 일치하지 않는 postId를 수신받을 경우에 아무 변화가 일어나지 않습니다.
      guard let postIndex = self?.posts.firstIndex(where: {$0.detail.postID == updatedPostCommentsEntity.postId }) else {
        return .none
      }
      
      if self?.hasEnteredPostDetailScene == false {
        return .none
      }
      
      self?.posts[postIndex].detail.comments = updatedPostCommentsEntity.postComments
      return .load(.reloadCell(IndexPath(item: postIndex, section: PostViewSection.post.rawValue)))
    }.eraseToAnyPublisher()
  }
  
  // MARK: - 포스트 공유 Stream
  func postShareNotifierByPostOptionSream() -> Output {
    return postShareNotifierByPostOption
      .map { element -> State in
        return .share(element.postTitle, element.postId)
      }.eraseToAnyPublisher()
  }
  
  func postShareSubjectStream(_ input: Input) -> Output {
    return input.postShareSubject.map { [weak self] indexPath -> State in
      guard let item = self?.postItem(at: indexPath.item) else {
        return .unexpectedError(description: "앱 내부 서비스 에러가 발생됬습니다.")
      }
      let title = item.header.contentInfo.title
      return .share(title, item.postId)
    }.eraseToAnyPublisher()
  }
  
  // MARK: - 포스트 필터 관련 Stream
  func postFilterLoadingStartSubjectStream() -> Output {
    postFilterLoadingStartSubject.map { [weak self] _ -> State in
      self?.lock.lock()
      self?.isPostFiltering = true
      self?.hasMorePages = true
      self?.lock.unlock()
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
            return .load(.postFilterLoaded)
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
            return .load(.postFilterLoaded)
          }.catch { error in
            return Just(State.unexpectedError(description: error.localizedDescription))
          }.eraseToAnyPublisher() ?? Just(
            State.unexpectedError(description: "앱 내부 동작 에러가 발생됬습니다.")
          ).eraseToAnyPublisher()
      }.eraseToAnyPublisher()
  }
  
  // MARK: - 피드 life cycle 관련 Stream
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
          .map { _ -> State in
            return .load(.viewDidLoad)
          }.catch { error in
            return Just(State.unexpectedError(description: error.localizedDescription))
          }.eraseToAnyPublisher() ?? Just(
            State.unexpectedError(description: "앱 동작 에러가 발생됬습니다.")
          ).eraseToAnyPublisher()
      }.eraseToAnyPublisher()
  }
  
  // MARK: - 포스트 페이징 관련 Stream
  func isAvailableNextPageStream(_ input: Input) -> Output {
    return input.isAvailableNextPage
      .map { [weak self] _ -> State in
        if let hasMorePages = self?.hasMorePages, !hasMorePages {
          return .pagination(.noMorePage)
        }
        self?.isPaging = true
        return .pagination(.loadingNextPage)
      }
      .eraseToAnyPublisher()
  }
  
  func fetchNextPageStream(_ input: Input) -> Output {
    return input.fetchNextPage
      .flatMap { [weak self] _ -> Output in
        guard let self else {
          return Just(.unexpectedError(description: "앱 동작 에러가 발생됬습니다.")).eraseToAnyPublisher()
        }
        return fetchPosts()
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
          }.eraseToAnyPublisher()
      }.eraseToAnyPublisher()
  }
  
  // MARK: - 포스트 Reload 관련 Stream
  func feedRefreshStream(_ input: Input) -> Output {
    return input.feedRefresh
      .flatMap { [weak self] in
        self?.isRefreshing = true
        return self?.fetchPosts()
          .map { _ -> State in
            return .load(.refresh)
          }.catch { error in
            return Just(State.unexpectedError(description: error.localizedDescription))
          }.eraseToAnyPublisher() ?? Just(
            State.unexpectedError(description: "앱 동작 중 에러가 발생됬습니다.")
          ).eraseToAnyPublisher()
      }.eraseToAnyPublisher()
  }
  
  func specificPostTappedStream(_ input: Input) -> Output {
    return input.specificPostTapped
      .map { [weak self] index -> State in
        guard let post = self?.posts[index] else {
          return .unexpectedError(description: ReferenceError.invalidReference.localizedDescription)
        }
        self?.hasEnteredPostDetailScene = true
        return .detailPostShow(post: post)
      }.eraseToAnyPublisher()
  }
  
  // MARK: - 포스트 차단 관련 stream
  func postHasBlockedHandlerStream() -> Output {
    return postHasBlockedHandler
      .receive(on: DispatchQueue.main) // 삭제로직은 sync 동작되는 main thread에서 담당하므로 동시성 문제 해결.
      .map { [weak self] postId -> State in
      let blockedPostIdIndex = self?.posts.firstIndex(where: {
        $0.detail.postID == postId
      })
      
      guard let blockedPostIdIndex else {
        return .unexpectedError(description: "앱 내부 동작 에러가 발생됬습니다. 차단된 포스트 아이디가 식별 불가능합니다.")
      }
      // MARK: 주의! posts 뿐 아니라 postThumbnails에 대해서도 동일하게 삭제해야합니다.
      /// PostViewAdapter에서는 posts가 아니라 postThumbnails 변수를 통해 cell identifier를식별하기 때문입니다.
      /// 주의!!!!! 나이스 - 석현이형 -
      self?.posts.remove(at: blockedPostIdIndex)
      self?.postThumbnails.remove(at: blockedPostIdIndex)
      return .load(.deleteBlockedPost(IndexPath(item: blockedPostIdIndex, section: PostViewSection.post.rawValue)))
    }.eraseToAnyPublisher()
  }
  
  /// 포스트 상세 화면에서 차단로직 호출될 경우 포스트 피드에서도 해당 포스트를 제거하는 로직입니다.
  func postBlockSubjectStream(_ input: Input) -> Output {
    return input.postBlockSubject.map { [weak self] blockedPostId -> State in
      self?.postHasBlockedHandler.send(blockedPostId)
      return .none
    }.eraseToAnyPublisher()
  }
}

// MARK: - Helpers
extension FeedPostViewModel {
  @inlinable
  func appendPosts(_ postPages: PostsPage) {
    lock.lock()
    posts += postPages.posts
    lock.unlock()
  }
}

// MARK: - Private Helpers
extension FeedPostViewModel {
  func removeAllPage() {
    lock.lock()
    currentPage = 0
    posts.removeAll()
    postThumbnails.removeAll()
    hasMorePages = true
    lock.unlock()
  }
  
  func bind() {
    bindPostOptionResult { [weak self] element in
      if let element = element {
        /// 섬네일 화면에서 해당 포스트 차단한 경우
        guard element.postOptionLocation == .summaryPage(nil) else {
          return
        }
        if case .summaryPage(let themeType) = element.postOptionLocation {
          if themeType?.rawValue == self?.category.mainTheme.rawValue {
            /// 포스트 옵션 뷰 모델에서 서머리 페이지에서 발생된 신고의 경우 해당 메인 카테고리의 어느 카테고리인지 명시하지 않으면,
            ///   노티피케이션 특징으로 인해 서로 다른 카테고리의 feed post viewModel에서 반응하게 됩니다.
            ///
            /// 포스트 상세화면에서 포스트가 차단될 경우, PostOptionVM에서 차단 완료 알림창을 수행합니다..
            self?.postHasBlockedHandler.send(element.postId)
          }
        }
      }
    } postShareHandler: { [weak self] element in
      self?.postShareNotifierByPostOption.send(element)
    }
    
    makeUpdatedPostCommentsNotificationSubscriber().store(in: &subscriptions)
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
        self?.lock.lock()
        self?.postThumbnails.append(contentsOf: postsPage.thumbnails.map { $0.postImageDataList })
        self?.currentPage += 1
        self?.lock.unlock()
        self?.appendPosts(postsPage)
      }
      .catch { [weak self] error -> AnyPublisher<Void, any Error> in
        if error.isNoMorePage {
          self?.lock.lock()
          self?.hasMorePages = false
          self?.lock.unlock()
          return Just(()).setFailureType(to: (any Error).self).eraseToAnyPublisher()
        }
        return Fail(error: error).eraseToAnyPublisher()
      }
      .eraseToAnyPublisher()
  }
}

// MARK: - FeedPostViewAdapterDataSource
extension FeedPostViewModel: FeedPostViewAdapterDataSource {
  func postInfoForPostOption(
    from indexPath: IndexPath
  ) -> PostOptionInfo {
    let post = posts[indexPath.row]
    return PostOptionInfo(
      postId: post.detail.postID,
      authorId: post.author.authorId,
      authorName: post.author.nickname,
      postTitle: post.detail.title)
  }
  
  var headerItem: PostFilterOptions {
    return .travelMainTheme(category.mainTheme)
  }
  
  var numberOfItems: Int {
    posts.count
  }
  
  func numberOfThumbnailsInPost(at index: Int) -> PostThumbnailCountValue {
    return PostThumbnailCountValue(postItem(at: index).content.thumbnailImageDataList.count)
  }
  
  /// PostThumbnails Cell의 선정은 postThumbnails 프로퍼티에 의해 결정됩니다.
  func postItem(at index: Int) -> PostInfo {
    let post = posts[index]
    let postInfo = PostMapper.toPostInfo(post, thumbnails: postThumbnails[index])
    return postInfo
  }
}
