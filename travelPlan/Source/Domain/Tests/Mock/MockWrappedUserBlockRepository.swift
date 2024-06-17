//
//  MockWrappedUserBlockRepository.swift
//  travelPlan
//
//  Created by 양승현 on 4/1/24.
//

import Foundation
import Combine

final class MockWrappedUserBlockRepository: UserBlockRepository {
  // MARK: - Properties
  var subscriptions = Set<AnyCancellable?>()
  let mockService = SessionProvider(session: MockSession.default)
  lazy var repository = DefaultUserBlockRepository(service: mockService)
}

extension MockWrappedUserBlockRepository {
  func blockUser(
    with userId: UserIdentifier
  ) -> AnyPublisher<BlockedUserIdentifyEntity, any Error> {
    return Just(BlockedUserIdentifyEntity(
      userId: 1234, isBlocked: true)
    ).setAnyErrorAndEraseToAnyPublisher()
  }
  
  func unblockUser(with blockedUserId: UserIdentifier) -> AnyPublisher<Void, any Error> {
    return Just(()).setAnyErrorAndEraseToAnyPublisher()
  }
  
  func fetchBlockedUsers() -> AnyPublisher<[BlockedUserIdentifyEntity], any Error> {
    return Just([
      .init(userId: 1234, isBlocked: true),
      .init(userId: 1234, isBlocked: true)])
    .setAnyErrorAndEraseToAnyPublisher()
  }
}
