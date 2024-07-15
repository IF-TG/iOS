//
//  DestinationSearchResultUseCase.swift
//  travelPlan
//
//  Created by SeokHyun on 7/15/24.
//

import Foundation
import Combine

protocol DestinationSearchResultUseCase {
  func fetchDestinationList(
    keyword: String,
    page: Int?,
    perPage: Int?
  ) -> AnyPublisher<[ThumbnailDestination], any Error>
}
