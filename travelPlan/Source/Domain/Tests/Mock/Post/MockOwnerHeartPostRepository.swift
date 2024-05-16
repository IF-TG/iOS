//
//  MockOwnerHeartPostRepository.swift
//  travelPlan
//
//  Created by 양승현 on 5/16/24.
//

import Combine
import Foundation
@testable import travelPlan

final class MockOwnerHeartPostRepository: OwnerHeartPostRepository {
  func fetchOwnerHeartPostIdentifiers() -> AnyPublisher<[PostIdentifier], any Error> {
    return Just(["tempPostId1", "tempPostId2"]).setFailureType(to: (any Error).self).eraseToAnyPublisher()
  }
  
  func hasOwnerHeartPost(postId: PostIdentifier) -> AnyPublisher<Bool, any Error> {
    return Just(true).setFailureType(to: (any Error).self).eraseToAnyPublisher()
  }
}
