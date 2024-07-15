//
//  DestinationSearchResultUseCase.swift
//  travelPlan
//
//  Created by SeokHyun on 7/15/24.
//

import Foundation
import Combine

/// 여행지 검색 결과
protocol DestinationSearchResultUseCase {
  func fetchDestinationList(
    keyword: String,
    page: Int32?,
    perPage: Int32?
  ) -> AnyPublisher<[ThumbnailDestination], any Error>
}
