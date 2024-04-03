//
//  PostDetailViewModelable.swift
//  travelPlan
//
//  Created by 양승현 on 4/2/24.
//

import Combine

struct PostDetailViewModelInput {
  let viewDidLoad = PassthroughSubject<Void, Never>()
  let commentSend = PassthroughSubject<String, Never>()
}

@frozen enum PostDetailViewModelState {
  case networkProcessing
  case reloadedData
  case reloadedComment
  case unexpectedError(description: String)
}

@frozen enum PostDetailCommentState {
  case commentSend
}

protocol PostDetailViewModelable: ViewModelable
where Input == PostDetailViewModelInput,
      State == PostDetailViewModelState,
      Output == AnyPublisher<State, Never> { }
