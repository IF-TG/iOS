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
  private let filterInfo: PostFilterInfo
  
  private let postUseCase: TempPostUseCase
  
  // MARK: - Lifecycle
  init(filterInfo: PostFilterInfo, postUseCase: TempPostUseCase) {
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
  var headerItem: PostFilterOptions {
    return .travelMainTheme(filterInfo.travelTheme)
  }
}
