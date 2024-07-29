//
//  DefaultDestinationLikeRepository.swift
//  travelPlan
//
//  Created by SeokHyun on 7/24/24.
//

import Foundation
import Combine

final class DefaultDestinationLikeRepository {
  // MARK: - Dependencies
  private let service: Sessionable
  private let backgroundQueue: DispatchQueue
  
  // MARK: - LifeCycle
  init(service: Sessionable, backgroundQueue: DispatchQueue = .global(qos: .userInitiated)) {
    self.service = service
    self.backgroundQueue = backgroundQueue
  }
}

// MARK: - DestinationLikeRepository
extension DefaultDestinationLikeRepository: DestinationLikeRepository {
  func toggleDestinationLike(destinationId: Int) -> AnyPublisher<DestinationLike, any Error> {
    let requestDTO = DestinationLikeRequestDTO(objectId: destinationId)
    let endpoint = DestinationLikeEndpoints.toggleLikeDestination(with: requestDTO)
    
    return service.request(endpoint: endpoint)
      .receive(on: backgroundQueue)
      .mapConnectionError()
      .map { $0.result.toDomain() }
      .eraseToAnyPublisher()
  }
}
