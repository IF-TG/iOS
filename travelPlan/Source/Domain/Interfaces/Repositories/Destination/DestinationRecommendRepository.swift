//
//  DestinationRecommendRepository.swift
//  travelPlan
//
//  Created by SeokHyun on 8/8/24.
//

import Foundation
import Combine

protocol DestinationRecommendRepository {
  /// 여행지 추천 list를 받아옵니다.
  func fetchRecommendationDestinationList(
    page: Int?,
    perPage: Int?
  ) -> AnyPublisher<[DestinationRecommendSection], any Error>
}
