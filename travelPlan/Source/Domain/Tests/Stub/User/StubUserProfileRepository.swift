//
//  StubUserProfileRepository.swift
//  travelPlan
//
//  Created by 양승현 on 5/16/24.
//

import Foundation
import Combine

struct StubUserProfileRepository: UserProfileRepository {
  func fetchProfileImageData(with userId: UserIdentifier) -> AnyPublisher<ProfileImageEntity, any Error> {
    return Just(ProfileImageEntity(image: "사용자프로필".data(using: .utf8)!))
      .setAnyErrorAndEraseToAnyPublisher()
  }
  
  func fetchProfile(with userId: UserIdentifier) -> AnyPublisher<UserEntity, any Error> {
    return Just(UserEntity(id: 1, nickname: "짱구", profileImageUrl: "", isSavedProfileInServer: false))
      .setAnyErrorAndEraseToAnyPublisher()
  }
}
