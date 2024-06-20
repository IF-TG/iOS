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
final class PostDetailCoordinator: NSObject, FlowCoordinator, PostOptionCoordinatable, AlertCoordinatable, PostShareCoordinatable {
  var parent: FlowCoordinator?
  var child: [FlowCoordinator] = []
  var presenter: UINavigationController?
  
  /// dismiss호출코드에서 finish도 해줘야합니다
  private var postDetailViewController: PostDetailViewController?
  weak private var viewModelPostReceivable: ReviewWritingPostReceivable?
  
  var blockedPost: ((PostIdentifier) -> Void)?
  
  init(presenter: UINavigationController?, post: Post?, postId: PostIdentifier) {
    self.presenter = presenter
    super.init()
    let mockPostRepository = MockPostRepository()
//    let defaultPostFetchUseCase = DefaultPostFetchUseCase(postRepository: mockPostRepository)
    let defaultPostFetchUseCase = MockPostFetchUseCase()
    let mockPostCommentRepository = MockPostCommentRepository()
    let defaultPostCommetnsAndPostLikeStateFetchUseCase = DefaultPostCommentsAndPostLikeStateFetchUseCase(
      postRepository: mockPostRepository)
    let mockPostNestedCommentRepository = MockPostNestedCommentRepository()
    let postCommentUseCase = DefaultPostCommentUseCase(postCommentRepository: mockPostCommentRepository)
    let loggedInUserRepository = DefaultLoggedInUserRepository(storage: .init(value: StubOwnerStorage()))
    let postNestedCommentUseCase = DefaultPostNestedCommentUseCase(
      postNestedCommentRepository: mockPostNestedCommentRepository)
    let userBlockUseCase = DefaultUserBlockUseCase(userBlockRepository: MockWrappedUserBlockRepository())
    
    let postCommentHeartUseCase = DefaultPostCommentHeartUseCase(postCommentRepository: mockPostCommentRepository)
    let postNestedCommentHeartUseCase = DefaultPostNestedCommentHeartUseCase(
      postNestedCommentRepository: mockPostNestedCommentRepository)
    
    let optionActions = PostOptionViewModelActions(
      showPostOption: { [weak self] optionCallback in self?.showOption(handler: optionCallback) },
      showPostOptionForMine: { [weak self] callback in self?.showPostOptionForMine(completion: callback)},
      showPostReport: { [weak self] reportCallback in self?.showPostReport(handler: reportCallback) },
      showPostReportResult: { [weak self] option in self?.showPostReportResult(wtih: option) },
      showPostAuthorBlock: { [weak self] authName, completion in
        self?.showPostAuthorBlock(authName, handler: completion)
      },
      showAlertForError: {[weak self] message, completion in
        self?.showAlertForError(with: message, completion: completion)
      })
    
    let actions = PostDetailViewModelActions(
      showAlertForError: { [weak self] message, completion in
        self?.showAlertForError(with: message, completion: completion)
      },
      showCategory: {[weak self] categories in self?.showCategory(with: categories) },
      showReviewWriting: { [weak self] entity in self?.showReviewWriting(entity: entity) },
      showFeedAfterBlockingFeed: { [weak self] blockedPostId in self?.showFeedAfterBlockingFeed(blockedPostId) },
      finishWithAnim: { [weak self] in self?.finishWithAnim() }, 
      showPostShare: { [weak self] element in
        self?.showPostShareSheet(with: .init(
          title: element.postTitle,
          postId: element.postId))}, 
      showPostShareSheet: { [weak self] postActivityItemSource in
        self?.showPostShareSheet(with: postActivityItemSource)
      })
    
    let chatActions = PostDetailChatViewModelActions(
      showAlertForError: { [weak self] message, completion in
        self?.showAlertForError(with: message, completion: completion)
      },
      showAnAlertToAskWhetherToCancelWriting: { [weak self] type, completion in
        self?.showAnAlertToAskWhetherToCancelWriting(type: type, completion: completion)
      },
      showCommentOption: { [weak self] isCommentOwner, optionCallBack in
        self?.showCommentOption(isCommentOwner: isCommentOwner, handler: optionCallBack)
      }, showPostAuthorBlock: { [weak self] authName, completion in
        self?.showPostAuthorBlock(authName, handler: completion)
      })
    
    let postDetailVM = PostDetailViewModel(
      post: post,
      postId: postId,
      postFetchUseCase: defaultPostFetchUseCase,
      ownerRepository: loggedInUserRepository,
      actions: actions)

    let postDetailChatVM = PostDetailChatViewModel(
      postId: postId,
      postCommentsAndPostLikeStateFetchUseCase: defaultPostCommetnsAndPostLikeStateFetchUseCase,
      postCommentUseCase: postCommentUseCase,
      postCommentHeartUseCase: postCommentHeartUseCase,
      postNestedCommentUseCase: postNestedCommentUseCase,
      postNestedCommentHeartUseCase: postNestedCommentHeartUseCase,
      userBlockUseCase: userBlockUseCase,
      ownerRepository: loggedInUserRepository,
      actions: chatActions)
    
    let postOptionDataSource = PostOptionViewModelInfo(
      postId: postId,
      postAuthorId: post?.author.authorId,
      postAuthorNickname: post?.author.nickname,
      postOptionLocation: .detailPage,
      postTitle: post?.detail.title)
    let postOptionVM = PostOptionViewModel(
      dataSource: postOptionDataSource,
      actions: optionActions,
      ownerRepository: loggedInUserRepository,
      userBlockUseCase: userBlockUseCase)
    
    postDetailViewController = PostDetailViewController(
      viewModel: postDetailVM,
      chatViewModel: postDetailChatVM,
      optionViewModel: postOptionVM)
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
  func finishWithAnim() {
    finish(withAnimated: true)
  }
  func showReviewWriting(entity: ReviewWritingEntity) {
    let reviewWritingCoordinator = ReviewWritingCoordinator(presenter: presenter, mode: .edit(entity))
    addChild(with: reviewWritingCoordinator)
  }
  
  func showAnAlertToAskWhetherToCancelWriting(type: PostDetailWritingCacnelType, completion: ((Bool) -> Void)?) {
    showAlertWithYesNo(with: type.alertMessage, message: nil, completion: completion)
  }
  
  func showCommentOption(isCommentOwner: Bool, handler: ((PostDetailCommentOption) -> Void)?) {
    guard isCommentOwner else {
      /// 이 로직은 타인일 경우 댓글 옵션으 클릭했을 때 보여지는 로직입니다.
      ///
      /// 타인은 댓글에서 옵션을 선택할 때 차단하기 기능을 선택 할 수 있습니다.
      /// 서버에서 제공하는 댓, 대댓글 신고하기 api가 없습니다.
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
  
  func showCategory(with categories: [String]) {
    let categoryViewController = PostDetailCategoryViewController(style: .plain, dataSource: categories)
    presenter?.pushViewController(categoryViewController, animated: true)
  }
  
  func showFeedAfterBlockingFeed(_ postId: Int64) {
    blockedPost?(postId)
    finish(withAnimated: true)
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
