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
    recentRepository.fetchRecentSearchHistory(page: page, perPage: perPage)
    
    // FIXME: - Will Erase
    return Just(SearchHistories(recent: .init(), recommendation: .init()))
      .setAnyErrorAndEraseToAnyPublisher()
  }
}
