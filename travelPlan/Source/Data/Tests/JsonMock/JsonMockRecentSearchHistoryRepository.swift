//
//  JsonMockRecentSearchHistoryRepository.swift
//  travelPlan
//
//  Created by SeokHyun on 7/23/24.
//

import Foundation
import Combine

final class JsonMockRecentSearchHistoryRepository {
  // MARK: - Properties
  private let repository: RecentSearchHistoryRepository
  
  // MARK: - LifeCycle
  init(dispatchQueue: DispatchQueue = .global(qos: .userInitiated)) {
    self.repository = DefaultRecentSearchHistoryRepository(
      service: SessionProvider(session: MockSession.default),
      backgroundQueue: dispatchQueue
    )
  }
}

// MARK: - RecentSearchHistoryRepository
extension JsonMockRecentSearchHistoryRepository: RecentSearchHistoryRepository {
  func fetchRecentSearchHistory(
    page: Int? = nil,
    perPage: Int? = nil
  ) -> AnyPublisher<[RecentSearchHistory], any Error> {
    MockUrlProtocol.requestHandler = { _ in
      let mockData = MockResponseType
        .searchHistory(.recentSearch)
        .mockDataLoader
      return (HTTPURLResponse(), mockData)
    }
    
    return repository.fetchRecentSearchHistory(page: page, perPage: perPage)
  }
}
