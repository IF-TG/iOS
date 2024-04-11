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
  let showAnAlertToAskWhetherToCancelWriting: (PostDetailWritingCacnelType, ((Bool) -> Void)?) -> Void
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
  let keyboardHideNotifier = PassthroughSubject<Void, Never>()
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
  
  case keyboard(PostDetailKeyboardState)
}

@frozen enum PostDetailViewDidLoadState {
  case loggedInUserInfo(userProfile: String?)
  case reloadedCommentsWithPostFavoriteInfo(Bool)
}

@frozen enum PostDetailKeyboardState {
  typealias WrittenComemnt = String
  /// 댓글 작성시
  case willShow
  // 댓글, 대댓글 편집 시
  case willShowWhenCommentEditStart(WrittenComemnt)
  
  /// 댓글 작성, 댓, 대댓 편집 취소
  case hideToWritingCancel
  /// 댓글 작성, 댓, 대댓 편집 진행
  case writingContinue
}

@frozen enum PostDetailNestedCommentState {
  
  typealias Section = Int
  typealias WrittenComemnt = String
  
  case sentSuccessfully(Section)
  
  /// 대댓글 삭제 후
  case reload(IndexPath)
  case reloadWhenLastNestedCommentDelete(IndexPath)
  case reloadWhenCommentUpdate(IndexPath)
}

@frozen enum PostDetailCommentState {
  typealias WrittenComemnt = String
  
  /// 초기에 실행됩니다.
  case reloadedComment
  /// 댓글 삭제 후 대댓글이 없는 경우
  case reloadWhenCommentDelete(Int)
  /// 댓글 삭제 후 대댓글이 있는 경우
  case reloadWithNestedCommentsWhenCommentDelete(Int)
  
  case reloadWhenCommentUpdate(Int)
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
