//
//  MockMyProfileRepository.swift
//  travelPlan
//
//  Created by 양승현 on 2/27/24.
//

import Foundation
import Combine

final class MockMyProfileRepository: MyProfileRepository {
  func fetchProfile() -> AnyPublisher<UserEntity, any Error> {
    return Fail(error: NSError(domain: "Repository", code: 0, userInfo: ["APIError":"서버에서 미 구현된 api 입니다."]))
      .eraseToAnyPublisher()
  }
  
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
  
  func updateProfileImage(with profile: String) -> AnyPublisher<Bool, Error> {
    return Future { promise in
      if profile == "무슨이유에서인지실패.." {
        promise(.success(false))
      }
      promise(.success(true))
    }.eraseToAnyPublisher()
  }
  
  func saveProfileImage(with profile: String) -> AnyPublisher<Bool, Error> {
    return Future { promise in
      if profile == "!!!!" {
        promise(.success(false))
      }
      promise(.success(true))
    }.eraseToAnyPublisher()
  }
  
  func deleteProfileImage() -> AnyPublisher<Bool, Error> {
    return Future { $0(.success(true)) }.eraseToAnyPublisher()
  }
  
  func fetchProfileImage() -> AnyPublisher<ProfileImageEntity, Error> {
    return Future { $0(.success(ProfileImageEntity(image: Data()))) }.eraseToAnyPublisher()
  }
  
  func fetchProfile(with userId: String) -> AnyPublisher<UserEntity, any Error> {
    return Future {
      $0(.success(
        UserEntity(id: userId, nickname: "사용자", profileImageData: nil, isSavedProfileInServer: false)))
    }.eraseToAnyPublisher()
  }
  func saveProfile(with userId: String, nickname: String, profileImageData: Data) -> AnyPublisher<Void, any Error> {
    fatalError("서버에서 미 구현된 api")
  }
}
