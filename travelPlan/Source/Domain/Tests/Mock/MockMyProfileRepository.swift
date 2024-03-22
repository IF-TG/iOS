//
//  MockMyProfileRepository.swift
//  travelPlan
//
//  Created by 양승현 on 2/27/24.
//

import Combine

final class MockMyProfileRepository: MyProfileRepository {
  var isProfileSavedInServer: Bool = false
  
  func updateUserNickname(with name: String) -> Future<Bool, Error> {
    return .init { promise in
      promise(.success(name == "어려운건 정복해나가는 맛이 있는거지"))
    }
  }
  
  /// 만약 사용자가 "토익은 어려워"라는 닉네임을 입력했을 때 가정
  func checkIfUserNicknameDuplicate(with name: String) -> Future<Bool, Error> {
    if name == "토익은 어려워" {
      return .init { promise in promise(.success(true)) }
    }
    return .init { $0(.success(false))}
  }
  
  func updateProfile(with profile: String) -> Future<Bool, Error> {
    return .init { promise in
      if profile == "무슨이유에서인지실패.." {
        promise(.success(false))
      }
      promise(.success(true))
    }
  }
  
  func saveProfile(with profile: String) -> Future<Bool, Error> {
    return .init { promise in
      if profile == "!!!!" {
        promise(.success(false))
      }
      promise(.success(true))
    }
  }
  
  func deleteProfile() -> Future<Bool, Error> {
    return .init { $0(.success(true)) }
  }
  
  func fetchProfile() -> Future<ProfileImageEntity, Error> {
    return .init { $0(.success(ProfileImageEntity(image: "hi"))) }
  }
}
