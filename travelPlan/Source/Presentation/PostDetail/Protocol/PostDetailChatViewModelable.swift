//
//  PostDetailChatViewModelable.swift
//  travelPlan
//
//  Created by 양승현 on 5/21/24.
//

import Combine
import Foundation

// MARK: - Page
protocol PostDetailChatViewModelPageDelegate: AnyObject {
  func showAlertForError(with description: String, completion: (() -> Void)?)
  
  func showCommentOption(section: PostDetailSection)
  func showNestedCommentOption(indexPath: IndexPath)
}

// MARK: - Actions
struct PostDetailChatViewModelActions {
  typealias isCommentOwner = Bool
  
  let showAlertForError: (String, (() -> Void)?) -> Void
  let showAnAlertToAskWhetherToCancelWriting: (PostDetailWritingCacnelType, ((Bool) -> Void)?) -> Void
  let showCommentOption: (isCommentOwner, ((PostDetailCommentOption) -> Void)?) -> Void
  let showPostAuthorBlock: (String, ((Bool) -> Void)?) -> Void
}

// MARK: - Input
struct PostDetailChatViewModelInput {
  typealias UserInputText = String
  
  let viewDidLoad = PassthroughSubject<Void, Never>()
  let keyboardHideNotifier = PassthroughSubject<Void, Never>()
  let commentSendHandler = PassthroughSubject<UserInputText, Never>()
  let replyStartNotifier = PassthroughSubject<Int, Never>()
}

// MARK: - State
@frozen enum PostDetailChatViewModelState {
  case none
  case networkProcessing
  case unexpectedError(description: String)
  case nestedComment(PostDetailNestedCommentState)
  case comment(PostDetailCommentState)
  
  case keyboard(PostDetailKeyboardState)
  case viewDidLoad(PostDetailChatViewDidLoadStream)
  case blockedChat(PostDetailChatBlockState)
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

@frozen enum PostDetailChatViewDidLoadStream {
  case reloadedCommentsWithPostFavoriteInfo(Bool)
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

@frozen enum PostDetailChatBlockState {
  typealias Section = Int
  case blockedComment(Section)
  case blockedNestedComment(IndexPath)
}

// MARK: - ViewModelable
protocol PostDetailChatViewModelable: ViewModelable
where Input == PostDetailChatViewModelInput,
      State == PostDetailChatViewModelState {
  typealias UserInputText = String
  typealias Section = Int
  typealias SectionType = PostDetailSection
}
