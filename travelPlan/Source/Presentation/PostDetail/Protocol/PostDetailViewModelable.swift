//
//  PostDetailViewModelable.swift
//  travelPlan
//
//  Created by 양승현 on 4/2/24.
//

import Foundation
import Combine
import SHCoordinator

/// 뷰 컨트롤러에서 사용할 타입. -> 코디네이터에서 구현
struct PostDetailViewModelActions {
  typealias isCommentOwner = Bool
  
  let showAlertForError: (String, (() -> Void)?) -> Void
  let showAnAlertToAskWhetherToCancelWrittingTheReply: (((Bool) -> Void)?) -> Void
  let showPostOption: (((PostDetailOption) -> Void)?) -> Void
  
  let showCommentOption: (isCommentOwner, ((PostDetailCommentOption) -> Void)?) -> Void
  let showPostAuthorBlock: (String, ((Bool) -> Void)?) -> Void
  /// 신고하기 종류 추가.
  let showPostReport: (((PostReportType) -> Void)?) -> Void
  let showPostReportResult: (PostDetailOption) -> Void
  let showCategory: (([String])) -> Void
}

struct PostDetailViewModelInput {
  typealias UserInputText = String
  
  let viewDidLoad = PassthroughSubject<Void, Never>()
  let commentSendHandler = PassthroughSubject<UserInputText, Never>()
  let replyStartNotifier = PassthroughSubject<Int, Never>()
  let replyDismissalConfirmationNorifier = PassthroughSubject<Void, Never>()
  let keyboardDidHideWhenReplyingToMessageNotifier = PassthroughSubject<Bool, Never>()
  let postReportNotifier = PassthroughSubject<PostReportType, Never>()
  let postAuthorBlockNotifier = PassthroughSubject<Void, Never>()
}

@frozen enum PostDetailViewModelState {
  case none
  case networkProcessing
  case viewDidLoad(PostDetailViewDidLoadState)
  case unexpectedError(description: String)
  case nestedComment(PostDetailNestedCommentState)
  case comment(PostDetailCommentState)
  case postReport
}

@frozen enum PostDetailViewDidLoadState {
  case loggedInUserInfo(userProfile: String?)
  case reloadedCommentsWithPostFavoriteInfo(Bool)
}

@frozen enum PostDetailNestedCommentState {
  typealias Section = Int
  case sentSuccessfully(Section)
  
  case keyboardState(KeyboardState)
  
  case replyCancellationAsk
  case replyCancel
  case replyContinue
  
  /// 대댓글 삭제 후
  case reload(IndexPath)
}

@frozen enum PostDetailCommentState {
  /// 초기에 실행됩니다.
  case reloadedComment
  /// 댓글 삭제 후
  case reloadWhenCommentDelete
}

@frozen enum PostDetailOptionState {
  case showUserBlock(String)
  case showUserReport
}

protocol PostDetailViewModelable: ViewModelable & PostDetailCoordinatorDelegate
where Input == PostDetailViewModelInput,
      State == PostDetailViewModelState,
      Output == AnyPublisher<State, Never> {
  typealias UserInputText = String
  typealias Section = Int
}
