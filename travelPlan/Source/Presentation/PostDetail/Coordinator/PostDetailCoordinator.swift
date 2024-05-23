//
//  PostDetailCoordinator.swift
//  travelPlan
//
//  Created by 양승현 on 4/2/24.
//

import UIKit
import SHCoordinator

@frozen enum PostDetailCommentOption: String, CaseIterable {
  case commentUpdate = "편집하기"
  case commentDelete = "삭제하기"
  case commentUserBlock = "차단하기"
}

@frozen enum PostDetailOption: String, CaseIterable {
  case postBlock = "차단하기"
  case postReport = "신고하기"
}

@frozen enum PostDetailWritingCacnelType {
  // 대댓글 작성
  case replyWrite
  // 대댓글 편집
  case replyEdit
  case commentEdit
  
  var alertMessage: String {
    switch self {
    case .replyWrite:
      "작성중인 대댓글을 취소하시겠습니까?"
    case .replyEdit:
      "대댓글 편집을 취소하시겠습니까?"
    case .commentEdit:
      "댓글 편집을 취소하시겠습니까?"
    }
  }
}

// MARK: - PostDetailCoordinator
final class PostDetailCoordinator: NSObject, FlowCoordinator {
  typealias PostId = Int32
  
  var parent: FlowCoordinator?
  var child: [FlowCoordinator] = []
  var presenter: UINavigationController?
  
  /// dismiss호출코드에서 finish도 해줘야합니다
  private var postDetailViewController: PostDetailViewController?
  weak private var viewModelPostReceivable: ReviewWritingPostReceivable?
  
  var blockedPost: ((PostId) -> Void)?
  
  init(presenter: UINavigationController?, post: Post, category: Post.Category) {
    self.presenter = presenter
    super.init()
    
    let mockPostRepository = MockPostRepository()
    let defaultPostFetchUseCase = DefaultPostFetchUseCase(postRepository: mockPostRepository)
    let defaultPostCommetnsAndPostLikeStateFetchUseCase = DefaultPostCommentsAndPostLikeStateFetchUseCase(
      postRepository: mockPostRepository)
    
    let postCommentUseCase = DefaultPostCommentUseCase(postCommentRepository: MockPostCommentRepository())
    let loggedInUserRepository = DefaultLoggedInUserRepository(storage: StubOwnerStorage())
    let postNestedCommentUseCase = DefaultPostNestedCommentUseCase(
      postNestedCommentRepository: MockPostNestedCommentRepository())
    let userBlockUseCase = DefaultUserBlockUseCase(userBlockRepository: MockWrappedUserBlockRepository())
    
    let actions = PostDetailViewModelActions(
      showAlertForError: { [weak self] message, completion in
        self?.showAlertForError(with: message, completion: completion)
      },
      showPostOption: { [weak self] optionCallback in self?.showOption(handler: optionCallback) },
      showPostAuthorBlock: { [weak self] authName, completion in
        self?.showPostAuthorBlock(authName, handler: completion)
      },
      showPostReport: { [weak self] reportCallback in self?.showPostReport(handler: reportCallback) },
      showPostReportResult: { [weak self] option in self?.showPostReportResult(wtih: option) },
      showCategory: {[weak self] categories in self?.showCategory(with: categories) },
      showReviewWriting: { [weak self] entity in self?.showReviewWriting(entity: entity) },
      showFeedAfterBlockingFeed: { [weak self] blockedPostId in self?.showFeedAfterBlockingFeed(blockedPostId) })
    
    let chatActions = PostDetailChatViewModelActions(
      showAlertForError: { [weak self] message, completion in
        self?.showAlertForError(with: message, completion: completion)
      },
      showAnAlertToAskWhetherToCancelWriting: { [weak self] type, completion in
        self?.showAnAlertToAskWhetherToCancelWriting(type: type, completion: completion)
      },
      showCommentOption: { [weak self] isCommentOwner, optionCallBack in
        self?.showCommentOption(isCommentOwner: isCommentOwner, handler: optionCallBack)
      })
    
    let postDetailVM = PostDetailViewModel(
      post: post,
      category: category,
      postFetchUsecase: defaultPostFetchUseCase,
      ownerRepository: loggedInUserRepository,
      userBlockUseCase: userBlockUseCase,
      actions: actions)
    
    let postDetailChatVM = PostDetailChatViewModel(
      postId: post.detail.postID,
      postCommentsAndPostLikeStateFetchUseCase: defaultPostCommetnsAndPostLikeStateFetchUseCase,
      postCommentUseCase: postCommentUseCase,
      postNestedCommentUseCase: postNestedCommentUseCase,
      ownerRepository: loggedInUserRepository,
      actions: chatActions)
    postDetailViewController = PostDetailViewController(
      viewModel: postDetailVM,
      chatViewModel: postDetailChatVM)
    self.viewModelPostReceivable = postDetailVM
    presenter?.delegate = self
  }
  
  deinit {
    print("deinit: \(Self.self)")
  }
  
  func start() {
    guard let postDetailViewController else { return }
    presenter?.pushViewController(postDetailViewController, animated: true)
  }
}

// MARK: - Actions Helpers
extension PostDetailCoordinator {
  func showReviewWriting(entity: ReviewWritingEntity) {
    let reviewWritingCoordinator = ReviewWritingCoordinator(presenter: presenter, mode: .edit(entity))
    addChild(with: reviewWritingCoordinator)
  }
  
  func showAlertForError(with description: String, completion: (() -> Void)?) {
    let alert = UIAlertController(title: nil, message: description, preferredStyle: .alert).set {
      $0.addAction(title: "OK", style: .default) { _ in completion?() }
    }
    postDetailViewController?.present(alert, animated: true)
  }
  
  func showAnAlertToAskWhetherToCancelWriting(type: PostDetailWritingCacnelType, completion: ((Bool) -> Void)?) {
    let alert = UIAlertController(title: type.alertMessage, message: nil, preferredStyle: .alert).set {
      $0.addAction(title: "아니요", style: .cancel) { _ in completion?(false) }
      $0.addAction(title: "예", style: .default) { _ in completion?(true) }
    }
    postDetailViewController?.present(alert, animated: true)
  }
  
  func showOption(handler: ((PostDetailOption) -> Void)?) {
    /// 액션시트에서 cancel은 하나밖에 안됩니다.
    let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    PostDetailOption.allCases.forEach { option in
      alert.addAction(title: option.rawValue, style: .destructive) { _ in handler?(option) }
    }
    alert.addAction(title: "취소", style: .cancel, handler: nil)
    presenter?.present(alert, animated: true)
  }
  
  func showCommentOption(isCommentOwner: Bool, handler: ((PostDetailCommentOption) -> Void)?) {
    guard isCommentOwner else {
      // 여기선 타인임으로 차단하기 기능만!!
      let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
      alert.addAction(title: "차단하기", style: .destructive) { _ in handler?(.commentUserBlock) }
      alert.addAction(title: "취소", style: .cancel, handler: nil)
      presenter?.present(alert, animated: true)
      return
    }
    let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    PostDetailCommentOption.allCases.forEach { option in
      if option == .commentUserBlock { return }
      alert.addAction(title: option.rawValue, style: .destructive) { _ in handler?(option) }
    }
    alert.addAction(title: "취소", style: .cancel, handler: nil)
    presenter?.present(alert, animated: true)
  }
  
  func showPostAuthorBlock(_ authorName: String, handler: ((Bool) -> Void)?) {
    let alert = UIAlertController(
      title: "‘\(authorName)’님을 차단하시겠습니까?",
      message: "이 유저의 모든 게시물이 보이지 않고\n회원님에게 좋아요, 댓글을 남길 수 없으며\n팔로우가 취소됩니다.",
      preferredStyle: .alert
    ).set {
      $0.addAction(title: "취소", style: .cancel) { _ in handler?(false) }
      $0.addAction(title: "차단", style: .destructive) { _ in handler?(true) }
    }
    presenter?.present(alert, animated: true)
  }
  
  func showPostReport(handler: ((PostReportType) -> Void)?) {
    let alert = UIAlertController(title: "신고하기", message: nil, preferredStyle: .alert)
    PostReportType.allCases.forEach { report in
      var isStoppedRequest = false
      if report == .stopRequest { isStoppedRequest = true }
      alert.addAction(title: report.toKorean, style: isStoppedRequest ? .destructive : .default) { _ in
        handler?(report)
      }
    }
    presenter?.present(alert, animated: true, completion: nil)
  }
  
  func showPostReportResult(wtih option: PostDetailOption) {
    switch option {
    case .postBlock:
      presenter?.present(PostOptionResultAlertController(type: .postAuthorBlock), animated: true)
    case .postReport:
      presenter?.present(PostOptionResultAlertController(type: .postReport), animated: true)
    }
  }
  
  func showCategory(with categories: [String]) {
    let categoryViewController = PostDetailCategoryViewController(style: .plain, dataSource: categories)
    presenter?.pushViewController(categoryViewController, animated: true)
  }
  
  func showFeedAfterBlockingFeed(_ postId: Int32) {
    blockedPost?(postId)
    finish(withAnimated: true)
  }
}

// MARK: - Fileprivate Helpers
fileprivate extension UIAlertController {
  func addAction(title: String, style: UIAlertAction.Style, handler: ((UIAlertAction) -> Void)?) {
    self.addAction(UIAlertAction(title: title, style: style, handler: handler))
  }
}

// MARK: - FlowCoordinatorNavigatable
extension PostDetailCoordinator: FlowCoordinatorNavigatable {
  var viewController: UIViewController? {
    postDetailViewController
  }
}

// MARK: - UINavigationControllerDelegate
extension PostDetailCoordinator: UINavigationControllerDelegate {
  func navigationController(
    _ navigationController: UINavigationController,
    didShow viewController: UIViewController,
    animated: Bool
  ) {
    handlePopViewController(navigationController, didShow: viewController, animated: animated)
  }
}

// MARK: - ReviewWritingPostReceivable
extension PostDetailCoordinator: ReviewWritingPostReceivable {
  func receive(post: Post?) {
    viewModelPostReceivable?.receive(post: post)
  }
}
