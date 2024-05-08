//
//  Future+sink.swift
//  travelPlan
//
//  Created by 양승현 on 5/8/24.
//

import Foundation
import Combine

public extension Future
where Output == Void, Failure == Error {
  
  /// 반환타입이 Void인 경우
  func sink(promise: @escaping Promise) -> AnyCancellable {
    return sink { completion in
      if case .failure(let error) = completion {
        promise(.failure(error))
      }
    } receiveValue: { _ in
      promise(.success(()))
    }
  }
}
