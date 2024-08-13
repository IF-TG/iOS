//
//  DefaultDestinationRecommendRepository.swift
//  travelPlan
//
//  Created by SeokHyun on 8/8/24.
//

import Foundation
import Combine

final class DefaultDestinationRecommendRepository {
  // MARK: - Dependencies
  private let service: any Sessionable
  private let backgroundQueue: DispatchQueue
  
  // MARK: - LifeCycle
  init(
    service: any Sessionable,
    backgroundQueue: DispatchQueue = .global(qos: .userInitiated)
  ) {
    self.service = service
    self.backgroundQueue = backgroundQueue
  }
}

// MARK: - DestinationRecommendRepository
extension DefaultDestinationRecommendRepository: DestinationRecommendRepository {
  func fetchRecommendationDestinationList(
    page: Int? = nil,
    perPage: Int? = nil
  ) -> AnyPublisher<[DestinationRecommendSection], any Error> {
    let requestDTO = PagingRequestDTO(page: page, perPage: perPage)
    let endpoint = DestinationRecommendAPIEndpoints.fetchRecommendList(with: requestDTO)
    
    return service.request(endpoint: endpoint)
      .mapConnectionError()
      .map { $0.result.map { $0.toDomain() } }
      .eraseToAnyPublisher()
  }
}
