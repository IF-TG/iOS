//
//  FeedPostViewModelable.swift
//  travelPlan
//
//  Created by 양승현 on 10/23/23.
//

import Combine
import Foundation

struct FeedPostViewModelInput {
  let feedRefresh: PassthroughSubject<Void, Never> = .init()
  let isAvailableNextPage: PassthroughSubject<Void, Never> = .init()
  let fetchNextPage: PassthroughSubject<Void, Never> = .init()
  
  let viewDidLoad: PassthroughSubject<Void, Never> = .init()
  let notifiedOrderFilterRequest: PassthroughSubject<TravelOrderType, Never>
  let notifiedMainThemeFilterRequest: PassthroughSubject<TravelMainThemeType, Never>
  let specificPostTapped: PassthroughSubject<Int, Never> = .init()
  let postBlockSubject: PassthroughSubject<UserIdentifier, Never> = .init()
  let postShareSubject: PassthroughSubject<IndexPath, Never> = .init()
  
  let postHeartSubject: PassthroughSubject<IndexPath, Never> = .init()
  
  init(
    notifiedOrderFilterRequest: PassthroughSubject<TravelOrderType, Never>,
    notifiedMainThemeFilterRequest: PassthroughSubject<TravelMainThemeType, Never>
  ) {
    self.notifiedOrderFilterRequest = notifiedOrderFilterRequest
    self.notifiedMainThemeFilterRequest = notifiedMainThemeFilterRequest
  }
}

@frozen enum FeedPostViewModelState {
  typealias Title = String
  typealias NumberOfHearts = Int32
  
  case pagination(FeedPostViewModelPaginationState)
  case unexpectedError(description: String)
  case networking
  case share(Title, PostIdentifier)
  case detailPostShow(post: Post)
  case load(FeedPostViewModelLoadState)
  case updatedHearts(IndexPath, NumberOfHearts)
  case none
}

@frozen enum FeedPostViewModelLoadState {
  // 댓글 총 개수 or 하트 총 개수 or 하트 여부가 변경될 때 이 case를 통해 ui를 업데이트해야합니다.
  case reloadCell(IndexPath)
  case viewDidLoad
  case refresh
  case postFilterLoaded
  case deleteBlockedPost(IndexPath)
}

@frozen enum FeedPostViewModelPaginationState {
  case nextPage(reloadCompletion: () -> Void)
  case loadingNextPage
  case noMorePage
}

protocol FeedPostViewModelable: ViewModelable
where Input == FeedPostViewModelInput,
      State == FeedPostViewModelState,
      Output == AnyPublisher<State, Never> { }
