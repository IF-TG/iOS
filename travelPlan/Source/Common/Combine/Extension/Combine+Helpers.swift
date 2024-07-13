//
//  Combine+Helpers.swift
//  travelPlan
//
//  Created by 양승현 on 5/10/24.
//

import Foundation
import Combine

public extension Publisher {
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

public extension Publisher where Self.Failure == Never {
  /// Just를 사용할때 any Error와 type erase를 해야할 경우 사용하면 편리합니다.
  func setAnyErrorAndEraseToAnyPublisher() -> AnyPublisher<Self.Output, any Error> {
    return self.setFailureType(to: (any Error).self).eraseToAnyPublisher()
  }
}

/// Delay를 넣은 후 type erase된 퍼블리셔를 방출할 때 사용합니다.
public extension Publisher {
  func eraseToAnyPublisherWithDelay<S>(
    for interval: S.SchedulerTimeType.Stride,
    tolerance: S.SchedulerTimeType.Stride? = nil,
    scheduler: S,
    options: S.SchedulerOptions? = nil
  ) -> AnyPublisher<Self.Output, Self.Failure> where S: Scheduler {
    return self
      .delay(for: interval, tolerance: tolerance, scheduler: scheduler, options: options)
      .eraseToAnyPublisher()
  }
}
/// promise를 사용할 때 에러는 promise 방출을 보장합니다.
/// 테스트할때 이 지점에 디버깅체크를 하면 수월하게 테스트를 할 수 있습니다.
public extension Publisher where Failure == Error {
  func sink(
    promise: @escaping Future<Output, Error>.Promise,
    receivedValue: @escaping ((Output) -> Void)
  ) -> AnyCancellable {
    return self.sink { completion in
      if case .failure(let error) = completion {
        promise(.failure(error))
      }
    } receiveValue: { output in
      receivedValue(output)
    }
  }
}
