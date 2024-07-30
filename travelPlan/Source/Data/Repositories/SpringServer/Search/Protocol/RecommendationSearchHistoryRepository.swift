//
//  RecommendationSearchHistoryRepository.swift
//  travelPlan
//
//  Created by SeokHyun on 7/18/24.
//

import Foundation
import Combine

/// 추천 검색 기록을 가져옵니다.
protocol RecommendationSearchHistoryRepository {
  func fetchHistory() -> AnyPublisher<[RecommendationSearchHistory], any Error>
}
