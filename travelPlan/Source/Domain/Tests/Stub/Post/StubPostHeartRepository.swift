//
//  StubPostHeartRepository.swift
//  travelPlan
//
//  Created by 양승현 on 5/16/24.
//

import Combine
import Foundation
@testable import travelPlan

final class StubPostHeartRepository: PostHeartRepository {
  func fetchPostHearts(_ postId: PostIdentifier) -> AnyPublisher<Int, any Error> {
    return Just(1).setAnyErrorAndEraseToAnyPublisher()
  }
  
  func heartPost(_ postId: PostIdentifier, userId: UserIdentifier) -> AnyPublisher<Void, any Error> {
    return Just(()).setAnyErrorAndEraseToAnyPublisher()
  }
  
  func hatePost(_ postId: PostIdentifier, userId: UserIdentifier) -> AnyPublisher<Void, any Error> {
    return Just(()).setAnyErrorAndEraseToAnyPublisher()
  }
  
  func updatePostHearts(_ postId: PostIdentifier, willHeartPost: Bool) -> AnyPublisher<Void, any Error> {
    return Just(()).setAnyErrorAndEraseToAnyPublisher()
  }
}
