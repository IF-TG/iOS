//
//  StubUserProfileSettingRepository.swift
//  travelPlan
//
//  Created by 양승현 on 2/27/24.
//

import Foundation
import Combine

// 이 객체는 전부 통신 성공을 가정합니다.
final class StubUserProfileSettingRepository: UserProfileSettingRepository {
  func updateUserNickname(with name: String) -> AnyPublisher<Bool, Error> {
    return Just(true).setAnyErrorAndEraseToAnyPublisher()
  }
  
  func checkIfUserNicknameDuplicate(with name: String) -> AnyPublisher<Bool, Error> {
    if name == "난당근" {
      return Just(true).setAnyErrorAndEraseToAnyPublisher()
    }
    return Just(false).setAnyErrorAndEraseToAnyPublisher()
  }
  
  func updateProfileImage(with profileImageData: Data) -> AnyPublisher<Bool, Error> {
    return Just(true).setAnyErrorAndEraseToAnyPublisher()
  }
  
  func saveProfileImage(with profileImageData: Data) -> AnyPublisher<Bool, Error> {
    return Just(true).setAnyErrorAndEraseToAnyPublisher()
  }
  
  func deleteProfileImage() -> AnyPublisher<Bool, Error> {
    return Just(true).setAnyErrorAndEraseToAnyPublisher()
  }
  
  func saveProfile(
    with userId: UserIdentifier,
    nickname: String,
    profileImageData: Data?
  ) -> AnyPublisher<Void, any Error> {
    return Just(()).setAnyErrorAndEraseToAnyPublisher()
  }
}
