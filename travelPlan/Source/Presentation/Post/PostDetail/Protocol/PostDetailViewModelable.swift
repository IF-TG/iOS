//
//  PostDetailViewModelable.swift
//  travelPlan
//
//  Created by 양승현 on 4/2/24.
//

import Foundation
import Combine
import SHCoordinator

/// 뷰 컨트롤러에서 사용할 타입 -> 뷰 모델에서 구현
protocol PostDetailViewModelPageDelegate: AnyObject {
  func showAlertForError(with description: String, completion: (() -> Void)?)
  func showCategory()
  func showReviewWriting()
  func showAlertAndDismiss(with description: String)
}

// MARK: - Actions
/// 뷰 모델에서 사용할 타입. -> 코디네이터에서 구현
struct PostDetailViewModelActions {
  typealias PostId = Int32
  typealias PostTitle = String
  typealias PostShareElement = (postId: PostId, postTitle: PostTitle)
  
  let showAlertForError: (String, (() -> Void)?) -> Void
  
  let showCategory: (([String])) -> Void
  
  let showReviewWriting: (ReviewWritingEntity) -> Void
  
  let showFeedAfterBlockingFeed: (PostId) -> Void
  
  let finishWithAnim: () -> Void
  
  let showPostShare: (PostShareElement) -> Void
}

// MARK: - Input
struct PostDetailViewModelInput {
  let viewDidLoad = PassthroughSubject<Void, Never>()
}

// MARK: - State
@frozen enum PostDetailViewModelState {
  case none
  case failedToFetchPost(description: String)
  case networkProcessing
  
  case viewDidLoad(PostDetailViewDidLoadState)
  case unexpectedError(description: String)
}

@frozen enum PostDetailViewDidLoadState {
  typealias Title = String
  typealias Duration = String
  
  case loggedInUserInfo(userProfile: Data?, isPostOwner: Bool)
  case naviTitleInfo((Title, Duration))
  /// Universal link에 의해 서버에서 postDetails를 받은 경우에 사용됩니다.
  case reloadData
}

// MARK: - ViewModelable
protocol PostDetailViewModelable: ViewModelable
where Input == PostDetailViewModelInput,
      State == PostDetailViewModelState,
      Output == AnyPublisher<State, Never> {
  typealias UserInputText = String
  typealias Section = Int
}
