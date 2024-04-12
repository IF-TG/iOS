//
//  DefaultReviewWritingRepository.swift
//  travelPlan
//
//  Created by SeokHyun on 4/9/24.
//

import Foundation
import Combine

final class DefaultReviewWritingRepository {
  // MARK: - Dependencies
  private let service: Sessionable
  private let backgroundQueue: DispatchQueue
  
  // MARK: - Properties
  private var subscriptions = Set<AnyCancellable>()
  
  // MARK: - LifeCycle
  init(service: Sessionable, backgroundQueue: DispatchQueue = .global(qos: .background)) {
    self.service = service
    self.backgroundQueue = backgroundQueue
  }
}

// MARK: - ReviewWritingRepository
extension DefaultReviewWritingRepository: ReviewWritingRepository {
  func uploadPost() -> AnyPublisher<Bool, Never> {
    return Just(true).eraseToAnyPublisher()
  }
}
