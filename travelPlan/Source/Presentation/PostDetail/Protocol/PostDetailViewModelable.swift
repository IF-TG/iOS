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
  func showPostOption()
  func showCategory()
  func showPostReportResult()
  func showReviewWriting()
}

// MARK: - Actions
/// 뷰 모델에서 사용할 타입. -> 코디네이터에서 구현
struct PostDetailViewModelActions {
  typealias PostId = Int32
  let showAlertForError: (String, (() -> Void)?) -> Void
  let showPostOption: (((PostDetailOption) -> Void)?) -> Void
  
  let showPostAuthorBlock: (String, ((Bool) -> Void)?) -> Void
  /// 신고하기 종류 추가.
  let showPostReport: (((PostReportType) -> Void)?) -> Void
  let showPostReportResult: (PostDetailOption) -> Void
  let showCategory: (([String])) -> Void
  
  let showReviewWriting: (ReviewWritingEntity) -> Void
  let showFeedAfterBlockingFeed: (PostId) -> Void
}

// MARK: - Input
struct PostDetailViewModelInput {
  
  let viewDidLoad = PassthroughSubject<Void, Never>()
  let postReportNotifier = PassthroughSubject<PostReportType, Never>()
  let postAuthorBlockNotifier = PassthroughSubject<Void, Never>()
}

// MARK: - State
@frozen enum PostDetailViewModelState {
  case none
  case networkProcessing
  
  case viewDidLoad(PostDetailViewDidLoadState)
  case unexpectedError(description: String)
  case postReport(PostReportState)
}

@frozen enum PostDetailViewDidLoadState {
  typealias Title = String
  typealias Duration = String
  
  case loggedInUserInfo(userProfile: Data?, isPostOwner: Bool)
  case naviTitleInfo((Title, Duration))
}

@frozen enum PostDetailOptionState {
  case showUserBlock(String)
  case showUserReport
}

@frozen enum PostReportState {
  case completeReport
  case completeUserBlock
}

// MARK: - ViewModelable
protocol PostDetailViewModelable: ViewModelable
where Input == PostDetailViewModelInput,
      State == PostDetailViewModelState,
      Output == AnyPublisher<State, Never> {
  typealias UserInputText = String
  typealias Section = Int
}
