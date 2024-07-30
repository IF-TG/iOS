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
