//
//  MockUserInfoRepository.swift
//  travelPlan
//
//  Created by 양승현 on 2/27/24.
//

import Combine

final class MockUserInfoRepository: UserInfoRepository {
  func isDuplicatedName(with name: String) -> Future<Bool, Never> {
    if name == "토익은 어려워" {
      return .init { promise in promise(.success(true)) }
    }
    return .init { $0(.success(false))}
  }
}
