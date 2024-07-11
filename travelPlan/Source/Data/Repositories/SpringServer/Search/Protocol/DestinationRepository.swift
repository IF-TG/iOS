//
//  DestinationRepository.swift
//  travelPlan
//
//  Created by SeokHyun on 6/30/24.
//

import Foundation
import Combine

protocol DestinationRepository {
  func getAllByKeyword() -> AnyPublisher<Void, Never>
  func getDestination() -> AnyPublisher<Void, Never>
}
