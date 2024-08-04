//
//  DefaultDestinationRepository.swift
//  travelPlan
//
//  Created by SeokHyun on 6/30/24.
//

import Foundation
import Combine

final class DefaultDestinationRepository {
  // MARK: - Dependencies
  private let service: Sessionable
  private let backgroundQueue: DispatchQueue
  
  // MARK: - LifeCycle
  init(service: Sessionable, backgroundQueue: DispatchQueue = .global(qos: .userInitiated)) {
    self.service = service
    self.backgroundQueue = backgroundQueue
  }
}

extension DefaultDestinationRepository: DestinationRepository {
  func fetchDestination(destinationId: DestinationIdEntity) -> AnyPublisher<DestinationEntity, any Error> {
    let requestDTO = DestinationRequestDTO(destinationId: destinationId.id,
                                           contentTypeId: destinationId.contentTypeId)
    let endpoint = DestinationAPIEndpoints.fetchDestination(with: requestDTO)
    
    return service.request(endpoint: endpoint)
      .subscribe(on: backgroundQueue)
      .mapConnectionError()
      .map { $0.result.toDomain() }
      .eraseToAnyPublisher()
  }
}
