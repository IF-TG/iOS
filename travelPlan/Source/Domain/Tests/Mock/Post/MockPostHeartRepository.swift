//
//  MockPostHeartRepository.swift
//  travelPlan
//
//  Created by 양승현 on 5/16/24.
//

import Combine
import Foundation
@testable import travelPlan

final class MockPostHeartRepository: PostHeartRepository {
  func fetchPostHearts(_ postId: String) -> AnyPublisher<Int, any Error> {
    return Just(1).setFailureType(to: (any Error).self).eraseToAnyPublisher()
  }
  
  func heartPost(_ postId: String, userId: String) -> AnyPublisher<Void, any Error> {
    return Just(()).setFailureType(to: (any Error).self).eraseToAnyPublisher()
  }
  
  func hatePost(_ postId: String, userId: String) -> AnyPublisher<Void, any Error> {
    return Just(()).setFailureType(to: (any Error).self).eraseToAnyPublisher()
  }
  
  func updatePostHearts(_ postId: String, willHeartPost: Bool) -> AnyPublisher<Void, any Error> {
    return Just(()).setFailureType(to: (any Error).self).eraseToAnyPublisher()
  }
}
