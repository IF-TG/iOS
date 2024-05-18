//
//  Publisher+.swift
//  travelPlan
//
//  Created by 양승현 on 5/16/24.
//

import Combine
import Foundation
import SHFirestoreService

extension Publisher where Failure == FirestoreServiceError {
  /// FirestoreService에서 발생되는 에러를 Error로 추상화합니다.
  /// 이때 공통적으로 분류되는 에러로도 캐스팅해서 반환할 수 있습니다.
  func eraseToError() -> AnyPublisher<Self.Output, any Error> {
    self.mapError { firestoreServiceError -> any Error in
      return firestoreServiceError.noMorePagesAsError
    }.eraseToAnyPublisher()
  }
}
