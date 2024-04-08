//
//  PostDetailViewModelable.swift
//  travelPlan
//
//  Created by 양승현 on 4/2/24.
//

import Combine
import SHCoordinator

struct PostDetailViewModelActions {
  let showAlertForError: (String, (() -> Void)?) -> Void
  let showAnAlertToAskWhetherToCancelWrittingTheReply: (((Bool) -> Void)?) -> Void
  let showOption: (((PostDetailOption) -> Void)?) -> Void
  let showPostAuthorBlock: (String, ((Bool) -> Void)?) -> Void
  /// 신고하기 종류 추가.
  let showPostReport: (((PostReportType) -> Void)?) -> Void
  let showPostReportResult: (PostDetailOption) -> Void
  
//  init(
//    showAlertForError: (String, (() -> Void)?) -> Void,
//    showAnAlertToAskWhetherToCancelWrittingTheReply: (((Bool) -> Void)?),
//    showOption: (((PostDetailOption) -> Void)?),
//    showPostAuthorBlock: (String, ((Bool) -> Void)?),
//    showPostReport: (((PostReportType) -> Void)?),
//    showPostReportResult: (PostDetailOption))
}

struct PostDetailViewModelInput {
  typealias UserInputText = String
  
  let viewDidLoad = PassthroughSubject<Void, Never>()
  let commentSendHandler = PassthroughSubject<UserInputText, Never>()
  let replyStartNotifier = PassthroughSubject<Int, Never>()
  let replyDismissalConfirmationNorifier = PassthroughSubject<Void, Never>()
  let keyboardDidHideWhenReplyingToMessageNotifier = PassthroughSubject<Bool, Never>()
  let postOptionNotifier = PassthroughSubject<PostDetailOption, Never>()
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
  case postOption(PostDetailOptionState)
  case postReport(PostDetailOption)
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

protocol PostDetailViewModelable: ViewModelable
where Input == PostDetailViewModelInput,
      State == PostDetailViewModelState,
      Output == AnyPublisher<State, Never> {
  typealias UserInputText = String
  
  var actions: PostDetailViewModelActions? { get }
}
