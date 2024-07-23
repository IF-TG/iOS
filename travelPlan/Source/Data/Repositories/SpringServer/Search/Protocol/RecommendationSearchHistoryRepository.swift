//
//  RecommendationSearchHistoryRepository.swift
//  travelPlan
//
//  Created by SeokHyun on 7/18/24.
//

import Foundation
import Combine

protocol RecommendationSearchHistoryRepository {
  func fetchHistory() -> AnyPublisher<[RecommendationSearchHistory], any Error>
}
