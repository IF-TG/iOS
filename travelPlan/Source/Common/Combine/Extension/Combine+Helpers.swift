//
//  Combine+Helpers.swift
//  travelPlan
//
//  Created by 양승현 on 5/10/24.
//

import Foundation
import Combine

extension Publisher {
  func subscribeAndReceive(
    on queue: DispatchQueue
  ) -> AnyPublisher<Output, Failure> {
    return self
      .subscribe(on: queue)
      .eraseToAnyPublisher()
      .receive(on: queue)
      .eraseToAnyPublisher()
  }
}

extension Publisher where Self.Failure == Never {
  /// Just를 사용할때 any Error와 type erase를 해야할 경우 사용하면 편리합니다.
  func setAnyErrorAndEraseToAnyPublisher() -> AnyPublisher<Self.Output, any Error> {
    return self.setFailureType(to: (any Error).self).eraseToAnyPublisher()
  }
}
