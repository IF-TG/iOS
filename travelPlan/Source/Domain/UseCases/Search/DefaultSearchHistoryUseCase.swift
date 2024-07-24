//
//  DefaultSearchHistoryUseCase.swift
//  travelPlan
//
//  Created by SeokHyun on 7/18/24.
//

import Foundation
import Combine

final class DefaultSearchHistoryUseCase {
  // MARK: - Dependencies
  private let recentRepository: any RecentSearchHistoryRepository
  private let recommendationRepository: any RecommendationSearchHistoryRepository
  
  // MARK: - Properties
  
  // MARK: - LifeCycle
  init(
    recentRepository: any RecentSearchHistoryRepository,
    recommendationRepository: any RecommendationSearchHistoryRepository
  ) {
    self.recentRepository = recentRepository
    self.recommendationRepository = recommendationRepository
  }
}

extension DefaultSearchHistoryUseCase: SearchHistoryUseCase {
  func fetchHistories(page: Int?, perPage: Int?) -> AnyPublisher<SearchHistories, any Error> {
    let recent = recentRepository.fetchRecentSearchHistory(page: page, perPage: perPage)
    let recommendation = recommendationRepository.fetchHistory()
    
    return Publishers.Zip(recent, recommendation)
      .map {
        SearchHistories(recent: $0, recommendation: $1)
      }
      .eraseToAnyPublisher()
  }
}
