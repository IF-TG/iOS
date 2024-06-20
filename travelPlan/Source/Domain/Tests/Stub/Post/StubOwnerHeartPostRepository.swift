//
//  StubOwnerHeartPostRepository.swift
//  travelPlan
//
//  Created by 양승현 on 5/16/24.
//

import Combine
import Foundation
@testable import travelPlan

final class StubOwnerHeartPostRepository: OwnerHeartPostRepository {
  func fetchOwnerHeartPostIdentifiers() -> AnyPublisher<[PostIdentifier], any Error> {
    return Just([11, 232]).setAnyErrorAndEraseToAnyPublisher()
  }
  
  func hasOwnerHeartPost(postId: PostIdentifier) -> AnyPublisher<Bool, any Error> {
    return Just(true).setAnyErrorAndEraseToAnyPublisher()
  }
}
