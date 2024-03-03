//
//  MockUserInfoRepository.swift
//  travelPlan
//
//  Created by 양승현 on 2/27/24.
//

import Combine

final class MockUserInfoRepository: UserInfoRepository {
  // 임시
  func updateUserNickname(with name: String) -> Future<Bool, MainError> {
    return .init { $0(.success(true))}
  }
  
  /// 만약 사용자가 "토익은 어려워"라는 닉네임을 입력했을 때 가정
  func checkIfUserNicknameDuplicate(with name: String) -> Future<Bool, MainError> {
    if name == "토익은 어려워" {
      return .init { promise in promise(.success(true)) }
    }
    return .init { $0(.success(false))}
  }
  
  // 임시
  func updateProfile(with profile: String) -> Future<Bool, MainError> {
    return .init { promise in promise(.success(true))}
  }
}
