//
//  FeedPostViewModel.swift
//  travelPlan
//
//  Created by 양승현 on 10/23/23.
//

import Foundation
import Combine

class FeedPostViewModel: PostViewModel {
  // MARK: - Properties
  private let filterInfo: FeedPostSearchFilterInfo
  
  private let postUseCase: PostUseCase
  
  // MARK: - Lifecycle
  init(filterInfo: FeedPostSearchFilterInfo, postUseCase: PostUseCase) {
    self.postUseCase = postUseCase
    self.filterInfo = filterInfo
    super.init(postUseCase: postUseCase)
  }
}

// MARK: - FeedPostViewModelable
extension FeedPostViewModel: FeedPostViewModelable {
  func transform(_ input: Input) -> AnyPublisher<State, Never> {
    return Publishers.MergeMany([
      viewDidLoadStream(input),
      postsStream()]
    ).eraseToAnyPublisher()
  }
}

private extension FeedPostViewModel {
  func viewDidLoadStream(_ input: Input) -> Output {
    return input.viewDidLoad
      .map {_ in return .none }
      .eraseToAnyPublisher()
  }
  func postsStream() -> Output {
    return $posts.map { _ in .updatePosts }.eraseToAnyPublisher()
  }
}

// MARK: - FeedPostViewAdapterDataSource
extension FeedPostViewModel: FeedPostViewAdapterDataSource {
  var headerItem: TravelCategorySortingType {
    return .detailCategory(filterInfo.travelTheme)
  }
}
