//
//  DefaultRecentSearchHistoryRepository.swift
//  travelPlan
//
//  Created by SeokHyun on 7/18/24.
//

import Foundation
import Combine

final class DefaultRecentSearchHistoryRepository {
  // MARK: - Dependencies
  private let service: Sessionable
  private let backgroundQueue: DispatchQueue
  
  // MARK: - LifeCycle
  init(service: Sessionable, backgroundQueue: DispatchQueue = .global(qos: .userInitiated)) {
    self.service = service
    self.backgroundQueue = backgroundQueue
  }
}

// MARK: - RecentSearchHistoryRepository
extension DefaultRecentSearchHistoryRepository: RecentSearchHistoryRepository {
  func fetchRecentSearchHistory(page: Int? = nil, perPage: Int? = nil) -> AnyPublisher<[RecentSearchHistory], any Error> {
    let requestDTO = RecentSearchHistoryRequestDTO(page: page, perPage: perPage)
    let endpoint = SearchHistoryEndpoints.fetchRecentHistory(with: requestDTO)
    
    return service.request(endpoint: endpoint)
      .receive(on: backgroundQueue)
      .mapConnectionError()
      .map { $0.result.map { $0.toDomain()} }
      .eraseToAnyPublisher()
  }
  
  // TODO: - DeleteAll, DeleteElement
}
