//
//  DestinationScrapRepository.swift
//  travelPlan
//
//  Created by SeokHyun on 7/11/24.
//

import Foundation
import Combine

protocol DestinationScrapRepository {
  func toggleDestinationScrap() -> AnyPublisher<Void, Never>
  func getDestination() -> AnyPublisher<Void, Never>
}
