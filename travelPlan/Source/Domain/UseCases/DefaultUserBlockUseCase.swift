//
//  DefaultUserBlockUseCase.swift
//  travelPlan
//
//  Created by 양승현 on 4/1/24.
//

import Foundation
import Combine

final class DefaultUserBlockUseCase: UserBlockUseCase {
  // MARK: - Dependencies
  private let userBlockRepository: UserBlockRepository
  
  // MARK: - Lifecycle
  init(userBlockRepository: UserBlockRepository) {
    self.userBlockRepository = userBlockRepository
  }
    
  func blockUser(with userId: Int64) -> AnyPublisher<BlockedUserEntity, any Error> {
    return userBlockRepository
      .blockUser(with: userId)
      .eraseToAnyPublisher()
  }
}
