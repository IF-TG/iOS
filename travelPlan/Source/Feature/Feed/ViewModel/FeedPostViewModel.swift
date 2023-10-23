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
  
  // MARK: - Lifecycle
  init(filterInfo: FeedPostSearchFilterInfo, postUseCase: PostUseCase) {
    self.filterInfo = filterInfo
    super.init(postUseCase: postUseCase)
  }
}

extension FeedPostViewModel: FeedPostViewModelable {
  func transform(_ input: Input) -> AnyPublisher<State, Never> {
    return .init(Just(.none))
  }
}

extension FeedPostViewModel: FeedPostViewAdapterDataSource {
  var headerItem: TravelCategorySortingType {
    return .detailCategory(filterInfo.travelTheme)
  }
}
