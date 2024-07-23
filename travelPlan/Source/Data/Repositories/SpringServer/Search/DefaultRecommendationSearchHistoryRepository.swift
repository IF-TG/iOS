//
//  DefaultRecommendationSearchHistoryRepository.swift
//  travelPlan
//
//  Created by SeokHyun on 7/18/24.
//

import Foundation
import Combine

final class DefaultRecommendationSearchHistoryRepository {
  // MARK: - Dependencies
  private let service: Sessionable
  private let backgroundQueue: DispatchQueue
  
  // MARK: - LifeCycle
  init(
    service: Sessionable,
    backgroundQueue: DispatchQueue = .global(qos: .userInitiated)) {
    self.service = service
    self.backgroundQueue = backgroundQueue
  }
}

extension DefaultRecommendationSearchHistoryRepository: RecommendationSearchHistoryRepository {
  func fetchHistory() -> AnyPublisher<[RecommendationSearchHistory], any Error> {
    return Just([RecommendationSearchHistory]()).setAnyErrorAndEraseToAnyPublisher()
  }
}
