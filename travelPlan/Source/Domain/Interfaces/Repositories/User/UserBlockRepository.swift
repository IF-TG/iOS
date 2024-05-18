//
//  UserBlockRepository.swift
//  travelPlan
//
//  Created by 양승현 on 4/1/24.
//

import Combine

protocol UserBlockRepository {
  func blockUser(with userId: String) -> AnyPublisher<BlockedUserIdentifyEntity, Error>
  func unblockUser(with blockedUserId: String) -> AnyPublisher<Void, Error>
  func fetchBlockedUsers() -> AnyPublisher<[BlockedUserIdentifyEntity], Error>
}
