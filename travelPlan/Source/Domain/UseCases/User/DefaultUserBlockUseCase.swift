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
    
  func blockUser(with userId: String) -> AnyPublisher<BlockedUserIdentifyEntity, any Error> {
    return userBlockRepository
      .blockUser(with: userId)
      .eraseToAnyPublisher()
  }
  
  func unblockUser(with blockedUserId: String) -> AnyPublisher<Void, any Error> {
    return userBlockRepository.unblockUser(with: blockedUserId)
  }
  
  func fetchBlockedUsers() -> AnyPublisher<[BlockedUserIdentifyEntity], any Error> {
    return userBlockRepository
      .fetchBlockedUsers()
      .eraseToAnyPublisher()
  }
}
