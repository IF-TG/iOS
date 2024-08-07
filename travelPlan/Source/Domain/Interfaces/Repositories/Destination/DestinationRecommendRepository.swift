//
//  DestinationRecommendRepository.swift
//  travelPlan
//
//  Created by SeokHyun on 8/8/24.
//

import Foundation
import Combine

protocol DestinationRecommendRepository {
  func fetchRecommendationDestinationList(
    page: Int?,
    perPage: Int?
  ) -> AnyPublisher<[DestinationRecommendSection], any Error>
}
