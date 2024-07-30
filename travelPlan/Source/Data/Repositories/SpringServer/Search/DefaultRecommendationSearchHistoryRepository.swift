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
    // FIXME: - mock을 제거하고 service 구현하기
    let mockHistories: [RecommendationSearchHistory] = [
      .init(keyword: "서울"),
      .init(keyword: "경기"),
      .init(keyword: "강원"),
      .init(keyword: "페스티벌"),
      .init(keyword: "공연"),
      .init(keyword: "캠핑"),
      .init(keyword: "바다"),
      .init(keyword: "서핑"),
      .init(keyword: "수영"),
    ]
    
    return Just(mockHistories).setAnyErrorAndEraseToAnyPublisher()
  }
}
