//
//  PostDetailViewModelable.swift
//  travelPlan
//
//  Created by 양승현 on 4/2/24.
//

import Combine
import SHCoordinator

/// 뷰 컨트롤러에서 사용할 타입. -> 코디네이터에서 구현
struct PostDetailViewModelActions {
  let showAlertForError: (String, (() -> Void)?) -> Void
  let showAnAlertToAskWhetherToCancelWrittingTheReply: (((Bool) -> Void)?) -> Void
  let showPostOption: (((PostDetailOption) -> Void)?) -> Void
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
}

@frozen enum PostDetailCommentState {
  case reloadedComment
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
}
