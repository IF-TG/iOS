//
//  MockMyProfileRepository.swift
//  travelPlan
//
//  Created by 양승현 on 2/27/24.
//

import Combine

final class MockMyProfileRepository: MyProfileRepository {
  var isProfileSavedInServer: Bool = false
  
  func updateUserNickname(with name: String) -> AnyPublisher<Bool, Error> {
    return Future { promise in
      promise(.success(name == "어려운건 정복해나가는 맛이 있는거지"))
    }.eraseToAnyPublisher()
  }
  
  /// 만약 사용자가 "토익은 어려워"라는 닉네임을 입력했을 때 가정
  func checkIfUserNicknameDuplicate(with name: String) -> AnyPublisher<Bool, Error> {
    return Future { promise in
      if name == "토익은 어려워" {
        promise(.success(true))
      }
      promise(.success(false))
    }.eraseToAnyPublisher()
  }
  
  func updateProfile(with profile: String) -> AnyPublisher<Bool, Error> {
    return Future { promise in
      if profile == "무슨이유에서인지실패.." {
        promise(.success(false))
      }
      promise(.success(true))
    }.eraseToAnyPublisher()
  }
  
  func saveProfile(with profile: String) -> AnyPublisher<Bool, Error> {
    return Future { promise in
      if profile == "!!!!" {
        promise(.success(false))
      }
      promise(.success(true))
    }.eraseToAnyPublisher()
  }
  
  func deleteProfile() -> AnyPublisher<Bool, Error> {
    return Future { $0(.success(true)) }.eraseToAnyPublisher()
  }
  
  func fetchProfile() -> AnyPublisher<ProfileImageEntity, Error> {
    return Future { $0(.success(ProfileImageEntity(image: "hi"))) }.eraseToAnyPublisher()
  }
}
