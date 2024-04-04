//
//  PostDetailViewModelable.swift
//  travelPlan
//
//  Created by 양승현 on 4/2/24.
//

import Combine

struct PostDetailViewModelInput {
  let viewDidLoad = PassthroughSubject<Void, Never>()
  let commentHandler = PassthroughSubject<PostDetailCommentInput, Never>()
  let replyStartNotifier = PassthroughSubject<Int, Never>()
  let replyDismissalConfirmationNorifier = PassthroughSubject<Void, Never>()
  let keyboardDidHideWhenReplyingToMessageNotifier = PassthroughSubject<Bool, Never>()
}

@frozen enum PostDetailViewModelState {
  case none
  case loggedInUserInfo(userProfile: String?)
  case networkProcessing
  case reloadedData
  case reloadedComment
  case unexpectedError(description: String)
  case nestedComment(PostDetailNestedCommentState)
}

@frozen enum PostDetailNestedCommentState {
  typealias Section = Int
  case completionSend(Section)
  
  case keyboardState(KeyboardState)
  
  case replyCancellationAsk
  case replyCancel
  case replyContinue
}

@frozen enum PostDetailCommentInput {
  case commentSend(String)
}

protocol PostDetailViewModelable: ViewModelable
where Input == PostDetailViewModelInput,
      State == PostDetailViewModelState,
      Output == AnyPublisher<State, Never> { }
