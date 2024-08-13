//
//  DestinationRepository.swift
//  travelPlan
//
//  Created by SeokHyun on 6/30/24.
//

import Foundation
import Combine

protocol DestinationRepository {
  func fetchDestination(destinationId: DestinationIdEntity) -> AnyPublisher<DestinationEntity, any Error>
}
