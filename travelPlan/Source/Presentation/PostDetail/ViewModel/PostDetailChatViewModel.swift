//
//  PostDetailChatViewModel.swift
//  travelPlan
//
//  Created by 양승현 on 5/21/24.
//

import Combine
import Foundation

final class PostDetailChatViewModel {
  // MARK: - Nested
  @frozen fileprivate enum CommentUseCaseInput {
    case send(PostDetailChatViewModelable.UserInputText)
    case edit(PostDetailChatViewModelable.UserInputText)
    case delete(PostDetailChatViewModelable.Section)
  }
  
  @frozen fileprivate enum NestedCommentUseCaseInput {
    case send(PostDetailChatViewModelable.UserInputText)
    case edit(PostDetailChatViewModelable.UserInputText)
    case delete(IndexPath)
  }

  // MARK: - Dependencies
  private let postCommentsAndPostLikeStateFetchUseCase: PostCommentsAndPostLikeStateFetchUseCase
  
  private let postCommentUseCase: PostCommentUseCase
  
  private let postNestedCommentUseCase: PostNestedCommentUseCase
  
  private let loggedInUserUseCase: LoggedInUserUseCase
  
  // MARK: - Properties
  private var comments: [PostCommentEntity] = []
  
  /// 사용자가 대댓글 작성중인 경우 not nil. 댓글을 작성중인 경우 nil
  private var replyingSection: Int?
  
  /// 사용자가 대댓글 수정중인 경우 not nil. 댓글을 수정하지 않을 경우 nil
  private var editingNestedCommentIndexPath: IndexPath?
  
  /// 사용자가 댓글 수정중인 경우 not nil, 댓글을 수정하지 않는 일반적인 경우 nil
  private var editingCommentSection: Int?
  
  private let actions: PostDetailChatViewModelActions
  
  // MARK: - Pagination Properties
  // TODO: - 댓글 페이징 추가해야합니다.
  private var isPaging: Bool = false
  
  private let perPage: Int32 = 15
  
  private var currentPage: Int32 = 0
  
  private var nextPage: Int32 { hasMorePages ? currentPage + 1 : currentPage }
  
  // 서버에서 얻어와야 합니다.
  private var totalCommentCount: Int32 = 0
  
  private var hasMorePages: Bool {
    let totalPageCount = totalCommentCount/perPage
    return currentPage < totalPageCount
  }
  
  // MARK: - Combine Properties
  private var subscriptions = Set<AnyCancellable?>()
  
  private let commentUseCaseNotifier = PassthroughSubject<CommentUseCaseInput, Never>()
  
  private let commentUseCaseHandler = PassthroughSubject<CommentUseCaseInput, Never>()
  
  private let commentEditNotifier = PassthroughSubject<Int, Never>()
  
  private let nestedCommentUseCaseNotifier = PassthroughSubject<NestedCommentUseCaseInput, Never>()
  
  private let nestedCommentUseCaseHandler = PassthroughSubject<NestedCommentUseCaseInput, Never>()
  
  private let nestedCommentEditNotifier = PassthroughSubject<IndexPath, Never>()
  
  private let keyboardDidHideHandler = PassthroughSubject<(PostDetailWritingCacnelType, Bool), Never>()
  
  // MARK: - Lifecycle
  init(
    postCommentsAndPostLikeStateFetchUseCase: PostCommentsAndPostLikeStateFetchUseCase,
    postCommentUseCase: PostCommentUseCase,
    postNestedCommentUseCase: PostNestedCommentUseCase,
    loggedInUserUseCase: LoggedInUserUseCase,
    actions: PostDetailChatViewModelActions
  ) {
    self.postCommentsAndPostLikeStateFetchUseCase = postCommentsAndPostLikeStateFetchUseCase
    self.postCommentUseCase = postCommentUseCase
    self.postNestedCommentUseCase = postNestedCommentUseCase
    self.loggedInUserUseCase = loggedInUserUseCase
    self.actions = actions
  }
}

// MARK: - PostDetailChatViewModelPageDelegate
extension PostDetailChatViewModel: PostDetailChatViewModelPageDelegate {
  func showAlertForError(with description: String, completion: (() -> Void)?) {
    actions.showAlertForError(description, completion)
  }
  
  func showCommentOption(section: PostDetailSection) {
    // TODO: - 아.. 댓글 작성자의 id가 있어야 하지만 entity에 없습니다.
    let comment = comments[section.sectionIndex]
    guard let loggedUserId = loggedInUserUseCase.id else {
      showAlertForError(with: "로그인 한 사용자만 이용 가능합니다.", completion: nil)
      return
    }
    // TODO: - 로그인한 사용자가 작성한 댓글인지 여부에 따라 사용자 신고 기능만 추가될건지, 댓글 삭제, 수정 기능만 추가될 것인지..
    // 만약 자신이라면, 삭제, 수정 기능
    // 만약 타인꺼 댓글이라면 신고 기능만,,,
    // 신고 기능 api도 없음으로 일단 자신꺼에 한정해 삭제, 수정 기능만 넣고 자신것이 아니라면 알림창으로 본인만 수정 가능하다고 보여주어야 합니다.
    let commentUploadedUserId = loggedUserId
    actions.showCommentOption(loggedUserId == commentUploadedUserId) { [weak self] commentOption in
      switch commentOption {
      case .commentDelete:
        self?.commentUseCaseNotifier.send(.delete(section.sectionIndex))
      case .commentUpdate:
        // MARK: - 업데이트는 로직을 isCommentUpdating 이걸 추가하면서 대댓글 작성 과 같게 로직을 짜야 합니다.
        // self?.commentUseCaseNotifier.send(.update(section))
        self?.commentEditNotifier.send(section.sectionIndex)
      case .commentUserBlock:
        self?.showAlertForError(with: "댓글 차단 기능은 다음 업데이트 때 구현될 예정입니다.", completion: nil)
      }
    }
  }
  
  func showNestedCommentOption(indexPath: IndexPath) {
    let commentSection = SectionType.commentIndex(section: indexPath.section)
    // TODO: - 아.. nestedCommentEntity에 대댓 작성한 UserId가 있어야 하지만 entity에 없습니다.
    let nestedComment = comments[commentSection].nestedComments[indexPath.row]
    
    guard let loggedUserId = loggedInUserUseCase.id else {
      showAlertForError(with: "로그인 한 사용자만 이용 가능합니다.", completion: nil)
      return
    }
    
    // TODO: - 로그인한 사용자가 작성한 댓글인지 여부에 따라 사용자 차단 기능만 추가될건지, 댓글 삭제, 수정 기능만 추가될 것인지..
    // 만약 자신이라면, 삭제, 수정 기능
    // 만약 타인꺼 댓글이라면 차단 기능만,,,
    // 신고 기능 api도 없음으로 일단 자신꺼에 한정해 삭제, 수정 기능만 넣고 자신것이 아니라면 알림창으로 보여주어야 합니다.
    let commentUploadedUserId = loggedUserId
    actions.showCommentOption(loggedUserId == commentUploadedUserId) { [weak self] commentOption in
      switch commentOption {
      case .commentDelete:
        self?.nestedCommentUseCaseNotifier.send(.delete(indexPath))
      case .commentUpdate:
        // MARK: - 업데이트는 로직을 isNestedCommentUpdating 이걸 추가하면서 대댓글 작성 과 같게 로직을 짜야 합니다.
        self?.nestedCommentEditNotifier.send(indexPath)
      case .commentUserBlock:
        self?.showAlertForError(with: "대댓글 차단 기능은 다음 업데이트 때 구현될 예정입니다.", completion: nil)
      }
    }
  }
}

// MARK: - PostDetailChatViewModelable
extension PostDetailChatViewModel: PostDetailChatViewModelable {
  func transform(_ input: PostDetailChatViewModelInput) -> Output {
    fatalError("미 구현")
  }
}

// MARK: - Private Stream Helpers
private extension PostDetailChatViewModel { }

// MARK: - PostDetailChatDataSource
extension PostDetailChatViewModel: PostDetailChatDataSource {
  var numberOfSections: NumberOfComments {
    comments.count
  }
  
  func numberOfRows(in section: PostDetailSection) -> Int {
    comments[section.commentIndex].nestedComments.count
  }
  
  func commentItem(in section: PostDetailSection) -> PostCommentInfo {
    let postComment = comments[section.commentIndex]
    let baseInfo: BasePostDetailCommentInfo = .init(
      commentId: postComment.commentId,
      userName: postComment.userName,
      userProfileImageData: postComment.userProfileImageData,
      timestamp: postComment.timestamp,
      comment: postComment.isDeleted ? "댓글이 삭제되었습니다." : postComment.comment,
      isOnHeart: postComment.isOnHeart,
      heartCountText: "\(postComment.hearts)")
    return .init(baseInfo: baseInfo, isDeleted: postComment.isDeleted)
  }
  
  func replyItem(at indexPath: IndexPath) -> PostReplyInfo {
    let commentIndex = SectionType.commentIndex(section: indexPath.section)
    let postComment = comments[commentIndex]
    let postReply = postComment.nestedComments[indexPath.row]
    
    let commentInfo = BasePostDetailCommentInfo(
      commentId: postReply.nestedCommentId,
      userName: postReply.nickname,
      userProfileImageData: postReply.userProfileImageData,
      timestamp: postReply.timestamp,
      comment: postReply.comment,
      isOnHeart: postReply.isOnHeart,
      heartCountText: "\(postReply.hearts)")
    return .init(
      isFirstReply: indexPath.row == 0,
      commentInfo: commentInfo)
  }
}
