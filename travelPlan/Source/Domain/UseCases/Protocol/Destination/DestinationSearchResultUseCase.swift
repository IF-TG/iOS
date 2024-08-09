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
    page: Int?,
    perPage: Int?
  ) -> AnyPublisher<[ThumbnailDestination], any Error>
  
  func toggleScrap(
    id: Int,
    folderName: String?
  ) -> AnyPublisher<DestinationScrapToggler, any Error>
}
