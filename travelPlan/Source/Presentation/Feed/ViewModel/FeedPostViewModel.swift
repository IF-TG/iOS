//
//  FeedPostViewModel.swift
//  travelPlan
//
//  Created by 양승현 on 10/23/23.
//

import Foundation
import Combine

final class FeedPostViewModel: PostViewModel, PostOptionNotificationBinder {
  typealias PostId = Int32
  
  // MARK: - Dependencies
  private let postFetchUseCase: PostFetchUseCase
  
  // MARK: - Properties
  var currentPage: Int32 = 0
  
  var nextPage: Int32 { hasMorePages ? currentPage + 1 : currentPage }
  
  let perPage: Int32 = 5
  
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
  
  private let postHasBlockedHandler = PassthroughSubject<PostId, Never>()
  
  private var subscriptions = Set<AnyCancellable>()
  
  private let postShareNotifierByPostOption = PassthroughSubject<PostShareElement, Never>()
  
  var postOptionNotificationSubscriptions = Set<AnyCancellable>()
  
  var userWantToSharePostNotifier = PassthroughSubject<PostShareElement, Never>()
  
  /// haspostBlocked notification으로부터 알림을 전달받습니다.
  var postHasBlockedNotifier = PassthroughSubject<PostBlockedElement?, Never>()
  
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
      postHasBlockedHandlerStream()]
    ).eraseToAnyPublisher()
  }
}

// MARK: - Private Helpers
private extension FeedPostViewModel {
  func postShareNotifierByPostOptionSream() -> Output {
    return postShareNotifierByPostOption
      .map { element -> State in
        return .share(element.postTitle, FeedPostViewModelState.PostId(element.postId))
      }.eraseToAnyPublisher()
  }
  
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
  
  /// 포스트 상세 화면에서 차단로직 호출될 경우 포스트 피드에서도 해당 포스트를 제거하는 로직입니다.
  func postBlockSubjectStream(_ input: Input) -> Output {
    return input.postBlockSubject.map { [weak self] blockedPostId -> State in
      self?.postHasBlockedHandler.send(blockedPostId)
      return .none
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
  
  func specificPostTappedStream(_ input: Input) -> Output {
    return input.specificPostTapped
      .map { [weak self] index -> State in
        guard let post = self?.posts[index] else {
          return .unexpectedError(description: ReferenceError.invalidReference.localizedDescription)
        }
        return .detailPostShow(post: post)
      }.eraseToAnyPublisher()
  }
  
  // MARK: - 포스트 차단
  func postHasBlockedHandlerStream() -> Output {
    return postHasBlockedHandler
      .receive(on: DispatchQueue.main) // 삭제로직은 sync 동작되는 main thread에서 담당하므로 동시성 문제 해결.
      .map { [weak self] postId -> State in
      let blockedPostIdIndex = self?.posts.firstIndex(where: {
        Int32($0.detail.postID)! == postId
      })
      
      guard let blockedPostIdIndex else {
        return .unexpectedError(description: "앱 내부 동작 에러가 발생됬습니다. 차단된 포스트 아이디가 식별 불가능합니다.")
      }
      // MARK: 주의! posts 뿐 아니라 postThumbnails에 대해서도 동일하게 삭제해야합니다.
      /// PostViewAdapter에서는 posts가 아니라 postThumbnails 변수를 통해 cell identifier를식별하기 때문입니다.
      /// 주의!!!!! 나이스 - 석현이형 -
      self?.posts.remove(at: blockedPostIdIndex)
      self?.postThumbnails.remove(at: blockedPostIdIndex)
      return .deleteBlockedPost(IndexPath(item: blockedPostIdIndex, section: PostViewSection.post.rawValue))
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
      // TODO: - 액션시트보여주기.
      self?.postShareNotifierByPostOption.send(element)
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
  func postInfoForPostOption(
    from indexPath: IndexPath
  ) -> PostOptionInfo {
    let post = posts[indexPath.row]
    // TODO: - 사용자 아이디는 존재해야합니다. 서버 api가 반영되니 post authorid 옵셔널 제거해야합니다.
    return PostOptionInfo(
      postId: Int32(post.detail.postID) ?? -1,
      authorId: Int32(post.author.authorId!) ?? -1,
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
