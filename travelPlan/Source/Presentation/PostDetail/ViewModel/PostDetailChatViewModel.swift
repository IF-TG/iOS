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
    case delete(PostDetailSection)
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
  
  private let ownerRepository: LoggedInUserRepository
  
  // MARK: - Properties
  private let postId: PostIdentifier
  
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
    postId: PostIdentifier,
    postCommentsAndPostLikeStateFetchUseCase: PostCommentsAndPostLikeStateFetchUseCase,
    postCommentUseCase: PostCommentUseCase,
    postNestedCommentUseCase: PostNestedCommentUseCase,
    ownerRepository: LoggedInUserRepository,
    actions: PostDetailChatViewModelActions
  ) {
    self.postId = postId
    self.postCommentsAndPostLikeStateFetchUseCase = postCommentsAndPostLikeStateFetchUseCase
    self.postCommentUseCase = postCommentUseCase
    self.postNestedCommentUseCase = postNestedCommentUseCase
    self.ownerRepository = ownerRepository
    self.actions = actions
  }
}

// MARK: - PostDetailChatViewModelPageDelegate
extension PostDetailChatViewModel: PostDetailChatViewModelPageDelegate {
  func showAlertForError(with description: String, completion: (() -> Void)?) {
    actions.showAlertForError(description, completion)
  }
  
  func showCommentOption(section: PostDetailSection) {
    let comment = comments[section.commentIndex]
    guard let ownerId = ownerRepository.id else {
      showAlertForError(with: "로그인 한 사용자만 이용 가능합니다.", completion: nil)
      return
    }
    actions.showCommentOption(ownerId == comment.authorId) { [weak self] commentOption in
      switch commentOption {
      case .commentDelete:
        self?.commentUseCaseNotifier.send(.delete(section))
      case .commentUpdate:
        // TODO: - 업데이트는 로직을 isCommentUpdating 이걸 추가하면서 대댓글 작성 과 같게 로직을 짜야 합니다.
        // self?.commentUseCaseNotifier.send(.update(section))
        self?.commentEditNotifier.send(section.sectionIndex)
      case .commentUserBlock:
        self?.showAlertForError(with: "댓글 차단 기능은 다음 업데이트 때 구현될 예정입니다.", completion: nil)
      }
    }
  }
  
  func showNestedCommentOption(indexPath: IndexPath) {
    let commentSectionIndex = SectionType.commentIndex(section: indexPath.section)
    let nestedComment = comments[commentSectionIndex].nestedComments[indexPath.row]
    
    guard let ownerId = ownerRepository.id else {
      showAlertForError(with: "로그인 한 사용자만 이용 가능합니다.", completion: nil)
      return
    }
    
    // TODO: - 로그인한 사용자가 작성한 댓글인지 여부에 따라 사용자 차단 기능만 추가될건지, 댓글 삭제, 수정 기능만 추가될 것인지..
    // 만약 자신이라면, 삭제, 수정 기능
    // 만약 타인꺼 댓글이라면 차단 기능만,,,
    // 신고 기능 api도 없음으로 일단 자신꺼에 한정해 삭제, 수정 기능만 넣고 자신것이 아니라면 알림창으로 보여주어야 합니다.
    actions.showCommentOption(ownerId == nestedComment.authorId) { [weak self] commentOption in
      switch commentOption {
      case .commentDelete:
        self?.nestedCommentUseCaseNotifier.send(.delete(indexPath))
      case .commentUpdate:
        // TODO: - 업데이트는 로직을 isNestedCommentUpdating 이걸 추가하면서 대댓글 작성 과 같게 로직을 짜야 합니다.
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
    return Publishers.MergeMany([
      handleCommentInputStream(input),
      commentUseCaseHandlerStream(),
      nestedCommentUseCaseHandlerStream(),
      replyStartNotifierStream(input),
      keyboardDidHideHandlerStream(),
      keyboardDidHideNotifierStream(input),
      commentUseCaseNotifierStream(),
      nestedCommentEditNotifierStream(),
      commentEditNotifierStream(),
      nestedCommentUseCaseNotifierStream(),
      viewDidLoadStream(input)
    ]).eraseToAnyPublisher()
  }
}

// MARK: - Private Stream Helpers
private extension PostDetailChatViewModel {
  /// 초기 viewDidLoad시점에 호출해야 합니다. -> post favorite여부파악.
  func viewDidLoadStream(_ input: Input) -> Output {
    return input.viewDidLoad
      .flatMap { [weak self] _ -> Output in
        guard let self else {
          return Just(.unexpectedError(description: "앱 내부 에러가 발생됬습니다.")).eraseToAnyPublisher()
        }
        let postCommentRequestValue = PostCommentsRequestValue(
          page: currentPage,
          perPage: perPage,
          postId: postId)
        return postCommentsAndPostLikeStateFetchUseCase.fetchCommentsAndPostLikeStatus(with: postCommentRequestValue)
          .map {[weak self] postCommentContainerEntity -> State in
            self?.comments += postCommentContainerEntity.comments
            return .viewDidLoad(
              .reloadedCommentsWithPostFavoriteInfo(postCommentContainerEntity.isFavorited))
          }.catch { error in
            return Just(State.unexpectedError(description: error.localizedDescription))
          }.eraseToAnyPublisher()
      }.eraseToAnyPublisher()
  }
  
  /// CommnetInput에서 send가 눌러질 경우. 댓글, 대댓글 작성 및 수정 등 전송 관련 로직 담당
  func handleCommentInputStream(_ input: Input) -> Output {
    input.commentSendHandler
      .map { [weak self] userInputText -> State in
        DispatchQueue.global(qos: .userInitiated).async {
          /// 대댓글인 작성 후 전송할 것인가?
          let isReplyWrittenForSend = self?.replyingSection != nil
          /// 대댓글 수정 후 전송할 것인가?
          let isReplyWrittenForEdit = self?.editingNestedCommentIndexPath != nil
          /// 댓글 수정 후 전송할 것인가?
          let isCommentWrittenForEdit = self?.editingCommentSection != nil
          
          if isReplyWrittenForSend {
            self?.nestedCommentUseCaseHandler.send(.send(userInputText))
          } else if isReplyWrittenForEdit {
            self?.nestedCommentUseCaseHandler.send(.edit(userInputText))
          } else if isCommentWrittenForEdit {
            self?.commentUseCaseHandler.send(.edit(userInputText))
          } else {
            // 일반적으로 댓글 작성시 호출됩니다.
            self?.commentUseCaseHandler.send(.send(userInputText))
          }
        }
        return .networkProcessing
      }.eraseToAnyPublisher()
  }
  
  /// 커맨트 유즈케이스 관련 전반적인 역할 담당.
  func commentUseCaseHandlerStream() -> Output {
    commentUseCaseHandler
      .flatMap { [weak self] useCaseInput in
        switch useCaseInput {
        case .send(let text):
          return self?.sendCommentStream(with: text) ?? Just(
            State.unexpectedError(description: "댓글을 전송할 수 없습니다.")
          ).eraseToAnyPublisher()
        case .edit(let userInputText):
          return self?.updateCommentStream(with: userInputText) ?? Just(
            State.unexpectedError(description: "댓글을 수정할 수 없습니다.")
          ).eraseToAnyPublisher()
        case .delete(let section):
          return self?.deleteCommentStream(with: section) ?? Just(
            State.unexpectedError(description: "댓글을 삭제할 수 없습니다.")
          ).eraseToAnyPublisher()
          
        }
      }.eraseToAnyPublisher()
  }
  
  func nestedCommentUseCaseHandlerStream() -> Output {
    return nestedCommentUseCaseHandler
      .flatMap { [weak self] useCaseInput in
        switch useCaseInput {
        case .send(let text):
          return self?.sendNestedCommentStream(with: text) ?? Just(
            State.unexpectedError(description: "대댓글을 전송할 수 없습니다.")
          ).eraseToAnyPublisher()
        case .edit(let editedText):
          return self?.updateNestedCommentStream(with: editedText) ?? Just(
            State.unexpectedError(description: "대댓글 편집에 실패했습니다.")
          ).eraseToAnyPublisher()
        case .delete(let indexPath):
          return self?.deleteNestedCommentStream(with: indexPath) ?? Just(
            State.unexpectedError(description: "앱 내부 에러가 발생됬습니다.대댓글을 삭제할 수 없습니다.")
          ).eraseToAnyPublisher()
        }
      }.eraseToAnyPublisher()
  }
  
  /// 옵션에서 편집하기가 될 경우 키보드 보여주는 로직
  func nestedCommentEditNotifierStream() -> Output {
    return nestedCommentEditNotifier
      .map { [weak self] indexPath -> State in
        self?.editingNestedCommentIndexPath = indexPath
        let commentIndex = SectionType.commentIndex(section: indexPath.section)
        guard let comment = self?.comments[commentIndex] else {
          return .unexpectedError(description: "앱 내부 에러가 발생됬습니다. 대댓글을 수정할 수 없습니다.")
        }
        let replyComment = comment.nestedComments[indexPath.row].comment
        return .keyboard(.willShowWhenCommentEditStart(replyComment))
      }.eraseToAnyPublisher()
  }
  
  func commentEditNotifierStream() -> Output {
    return commentEditNotifier
      .map { [weak self] section -> State in
        self?.editingCommentSection = section
        let commentIndex = SectionType.commentIndex(section: section)
        guard let comment = self?.comments[commentIndex] else {
          return State.unexpectedError(description: "앱 내부 에러가 발생됬습니다. 대댓글을 수정할 수 없습니다.")
        }
        return .keyboard(.willShowWhenCommentEditStart(comment.comment))
      }.eraseToAnyPublisher()
  }
  
  func replyStartNotifierStream(_ input: Input) -> Output {
    input.replyStartNotifier.map { [weak self] replySection -> State in
      self?.replyingSection = replySection
      return .keyboard(.willShow)
    }.eraseToAnyPublisher()
  }
  
  // 댓, 대댓, 등 키보드가 사라질때 여기서 처리합니다
  func keyboardDidHideHandlerStream() -> Output {
    return keyboardDidHideHandler
      .map { [weak self] (writingCancelType, wannaCancel) -> State in
        switch writingCancelType {
        case .replyWrite:
          if wannaCancel {
            self?.replyingSection = nil
            return .keyboard(.hideToWritingCancel)
          }
          return .keyboard(.writingContinue)
        case .replyEdit:
          if wannaCancel {
            self?.editingNestedCommentIndexPath = nil
            return .keyboard(.hideToWritingCancel)
          }
          return .keyboard(.writingContinue)
        case .commentEdit:
          if wannaCancel {
            self?.editingCommentSection = nil
            return .keyboard(.hideToWritingCancel)
          }
          return .keyboard(.writingContinue)
        }
      }.eraseToAnyPublisher()
  }
  
  func keyboardDidHideNotifierStream(_ input: Input) -> Output {
    return input.keyboardHideNotifier
      .map { [weak self] _ -> State in
        let isReplyWrittenForSend = self?.replyingSection != nil
        let isReplyWrittenForEdit = self?.editingNestedCommentIndexPath != nil
        let isCommentWrittenForEdit = self?.editingCommentSection != nil
        
        if isReplyWrittenForSend {
          self?.actions.showAnAlertToAskWhetherToCancelWriting(.replyWrite) { wannaCancel in
            self?.keyboardDidHideHandler.send((.replyWrite, wannaCancel))
          }
        } else if isReplyWrittenForEdit {
          self?.actions.showAnAlertToAskWhetherToCancelWriting(.replyEdit) { wannaCancel in
            self?.keyboardDidHideHandler.send((.replyEdit, wannaCancel))
          }
        } else if isCommentWrittenForEdit {
          self?.actions.showAnAlertToAskWhetherToCancelWriting(.commentEdit) { wannaCancel in
            self?.keyboardDidHideHandler.send((.commentEdit, wannaCancel))
          }
        }
        return .none
      }.eraseToAnyPublisher()
  }
  
  func commentUseCaseNotifierStream() -> Output {
    return commentUseCaseNotifier.map { commentInput -> State in
      DispatchQueue.global(qos: .userInitiated).async { [weak self] in
        self?.commentUseCaseHandler.send(commentInput)
      }
      return .networkProcessing
    }.eraseToAnyPublisher()
  }
  
  /// 이거 새로 개발한 인디케이터 쓰면 없어질 예정....
  func nestedCommentUseCaseNotifierStream() -> Output {
    return nestedCommentUseCaseNotifier.map { nestedCommentInput -> State in
      DispatchQueue.global(qos: .userInitiated).async { [weak self] in
        self?.nestedCommentUseCaseHandler.send(nestedCommentInput)
      }
      return .networkProcessing
    }.eraseToAnyPublisher()
  }
}

// MARK: - Transform Inner stream Private Helpers
private extension PostDetailChatViewModel {
  // MARK: - Comment Stream
  /// 댓글 전송할 때
  func sendCommentStream(with text: String) -> Output {
    postCommentUseCase.sendComment(postId: postId, comment: text)
      .map { [weak self] postCommentEntity -> State in
        self?.comments.append(postCommentEntity)
        return .comment(.reloadedComment)
      }.catch { error in
        return Just(State.unexpectedError(description: error.localizedDescription))
      }.eraseToAnyPublisher()
  }
  
  func deleteCommentStream(with section: PostDetailSection) -> Output {
    /// 포스트는 섹션 \(PostDetailSectionType.defaultNumberOfSections)부터 시작합니다.
    let commentId = comments[section.commentIndex].commentId
    return postCommentUseCase
      .deleteComment(postId: postId, commentId: commentId)
      .map { [weak self] result -> State in
        if result {
          self?.comments[section.commentIndex].isDeleted = result
          
          guard let nestedCommentCount = self?.comments[section.commentIndex].nestedComments.count else {
            return .unexpectedError(description: "댓글이 삭제되지 않았습니다.")
          }
          
          /// 대댓글 있는 경우
          if nestedCommentCount > 0 {
            return .comment(.reloadWithNestedCommentsWhenCommentDelete(section.sectionIndex))
          }
          
          /// 대댓글 없는 경우
          self?.comments.remove(at: section.commentIndex)
          return .comment(.reloadWhenCommentDelete(section.sectionIndex))
        }
        return .unexpectedError(description: "서버에서 에러가 발생되 댓글이 삭제되지 않았습니다.")
      }.catch { error in
        return Just(State.unexpectedError(description: error.localizedDescription))
      }.eraseToAnyPublisher()
  }
  
  func updateCommentStream(with editedText: String) -> Output {
    guard let section = editingCommentSection else {
      return Just(State.unexpectedError(description: "대댓글을 수정할 수 없습니다.")).eraseToAnyPublisher()
    }
    let commentIdx = SectionType.commentIndex(section: section)
    let comment = comments[commentIdx]
    return postCommentUseCase
      .updateComment(postId: postId, commentId: comment.commentId, comment: editedText)
      .map { [weak self] result -> State in
        guard result else {
          return .unexpectedError(description: "서버에서 에러가 발생되어 댓글이 편집되지 않았습니다.")
        }
        self?.comments[commentIdx].comment = editedText
        self?.editingCommentSection = nil
        return .comment(.reloadWhenCommentUpdate(section))
      }.catch { error in
        return Just(State.unexpectedError(description: error.localizedDescription))
      }.eraseToAnyPublisher()
  }
  
  // MARK: - Nested Comment Stream
  /// 대댓글 전송할 때
  func sendNestedCommentStream(with text: String) -> Output {
    guard let replyingSection else {
      return Just(State.unexpectedError(description: "대댓글을 전송할 수 없습니다.")).eraseToAnyPublisher()
    }
    /// 포스트는 섹션 \(PostDetailSectionType.defaultNumberOfSections)부터 시작합니다.
    let commentSection = SectionType.commentIndex(section: replyingSection)
    let commentId = comments[commentSection].commentId
    return postNestedCommentUseCase
      .sendNestedComment(postId: postId, commentId: commentId, comment: text)
      .map { [weak self] postNestedCommentEntity -> State in
        self?.comments[commentSection].nestedComments.append(postNestedCommentEntity)
        self?.replyingSection = nil
        /// 대댓글이 속한 댓글 섹션은 replyingSection을 보내주어야 합니다.
        return .nestedComment(.sentSuccessfully(replyingSection))
      }.catch { error in
        return Just(State.unexpectedError(description: error.localizedDescription))
      }.eraseToAnyPublisher()
  }
  
  // MARK: 삭제된건 더이상 댓글 못달도록 UI 반영해야합니다!
  func deleteNestedCommentStream(with indexPath: IndexPath) -> Output {
    /// 포스트는 섹션 \(PostDetailSectionType.defaultNumberOfSections)부터 시작합니다.
    let commentSectionIndex = SectionType.commentIndex(section: indexPath.section)
    let nestedCommentId = comments[commentSectionIndex].nestedComments[indexPath.row].nestedCommentId
    let commentId = comments[commentSectionIndex].commentId
    let hasDeletedComment = comments[commentSectionIndex].isDeleted
    return postNestedCommentUseCase
      .deleteNestedComment(
        postId: postId,
        commentId: commentId,
        nestedCommentId: nestedCommentId,
        hasDeletedComment: hasDeletedComment)
      .map { [weak self] deletedNestedCommentState -> State in
        /// 대댓글 제거
        self?.comments[commentSectionIndex].nestedComments.remove(at: indexPath.row)
        
        // TODO: - 이 로직은 서버에서 대댓글제거할때 마지막 대댓글인지 확인해야하는데, 스프링에선 대댓글 제거만으로 알 수 없습니다.
        /// 그래서 임시적으로 이곳에서 작업합니다.
        /// 서버에서 현재 대댓글 개수가 몇 개인지 알수있는 api있으면 더 확실하게 좋을거같습니다.
        if self?.comments[commentSectionIndex].nestedComments.count == 0 && hasDeletedComment {
          self?.comments.remove(at: commentSectionIndex)
          /// 테이블뷰에 실제로 특정 셀 제거 후 리로드 명령은 실제 indexPath로 해야합니다.
          return .nestedComment(.reloadWhenLastNestedCommentDelete(indexPath))
        }
        
        switch deletedNestedCommentState {
        case .justANestedCommentDeleted:
          return .nestedComment(.reload(indexPath))
          
          /// 마지막 대댓글과 댓글도 제거된 경우
        case .ACommentAndAllNestedCommentsDeleted:
          self?.comments.remove(at: commentSectionIndex)
          /// 테이블뷰에 실제로 특정 셀 제거 후 리로드 명령은 실제 indexPath로 해야합니다.
          return .nestedComment(.reloadWhenLastNestedCommentDelete(indexPath))
        }
      }.catch { error in
        return Just(State.unexpectedError(description: error.localizedDescription))
      }.eraseToAnyPublisher()
  }
  
  func updateNestedCommentStream(with editedText: String) -> Output {
    guard let indexPath = editingNestedCommentIndexPath else {
      return Just(State.unexpectedError(description: "대댓글을 수정할 수 없습니다.")).eraseToAnyPublisher()
    }
    let commentIdx = SectionType.commentIndex(section: indexPath.section)
    let nestedComment = comments[commentIdx].nestedComments[indexPath.row]
    let commentId = comments[commentIdx].commentId
    return postNestedCommentUseCase
      .updateNestedComment(
        postId: postId,
        commentId: commentId,
        nestedCommentId: nestedComment.nestedCommentId,
        comment: editedText)
      .map { [weak self] result -> State in
        guard result else {
          return .unexpectedError(description: "서버에서 에러가 발생되어 대댓글이 편집되지 않았습니다.")
        }
        self?.comments[commentIdx].nestedComments[indexPath.row].comment = editedText
        
        self?.editingNestedCommentIndexPath = nil
        return .nestedComment(.reloadWhenCommentUpdate(indexPath))
      }.catch { error in
        return Just(State.unexpectedError(description: error.localizedDescription))
      }.eraseToAnyPublisher()
  }
}

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
