//
//  DefaultDestinationSearchRepository.swift
//  travelPlan
//
//  Created by SeokHyun on 7/14/24.
//

import Foundation
import Combine

final class DefaultDestinationSearchRepository {
  // MARK: - Dependencies
  private let service: Sessionable
  private let backgroundQueue: DispatchQueue
  
  // MARK: - Properties
  private var subscriptions = Set<AnyCancellable>()
  
  // MARK: - LifeCycle
  init(service: Sessionable, backgroundQueue: DispatchQueue = .global(qos: .userInitiated)) {
    self.service = service
    self.backgroundQueue = backgroundQueue
  }
}

extension DefaultDestinationSearchRepository: DestinationSearchRepository {
  func fetchDestinationList(
    by keyword: String,
    page: Int? = nil,
    perPage: Int? = nil
  ) -> AnyPublisher<[ThumbnailDestination], any Error> {
    let requestDTO = DestinationSearchRequestDTO(keyword: keyword, page: page, perPage: perPage)
    let endpoint = DestinationSearchEndpoints.fetchDestinationList(with: requestDTO)
    
    return service.request(endpoint: endpoint)
      .receive(on: backgroundQueue)
      .mapConnectionError()
      .map { $0.result.toDomain() }
      .eraseToAnyPublisher()
  }
}
