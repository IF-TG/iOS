//
//  FeedPostViewModelable.swift
//  travelPlan
//
//  Created by 양승현 on 10/23/23.
//

import Combine
import Foundation

struct FeedPostViewModelInput {
  typealias ImageData = Data
  let feedRefresh: PassthroughSubject<Void, Never> = .init()
  let nextPage: PassthroughSubject<Void, Never> = .init()
  let viewDidLoad: PassthroughSubject<Void, Never> = .init()
  let notifiedOrderFilterRequest: PassthroughSubject<TravelOrderType, Never>
  let notifiedMainThemeFilterRequest: PassthroughSubject<TravelMainThemeType, Never>
  let specificPostTapped: PassthroughSubject<Int, Never> = .init()
  let postBlockSubject: PassthroughSubject<Int32, Never> = .init()
  let postShareSubject: PassthroughSubject<(IndexPath, ImageData), Never> = .init()
  
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
  typealias PostId = Int
  typealias PostImageData = Data
  
  case viewDidLoad
  case refresh
  case pagination(FeedPostViewModelPaginationState)
  case unexpectedError(description: String)
  case networking
  case postFilterLoaded
  case share(Title, PostId, PostImageData)
  ///
  case detailPostShow(post: Post, category: Post.Category)
  case deleteBlockedPost(IndexPath)
  case none
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
