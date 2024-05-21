//
//  UserProfileResponseDTO.swift
//  travelPlan
//
//  Created by 양승현 on 4/25/24.
//

import Foundation

struct UserProfileResponseDTO: Decodable {
  let uid: String
  let nickname: String
  let profileImagePath: String
}

// MARK: - Helpers
extension UserProfileResponseDTO {
  func toDomain(with profileData: Data?) -> UserEntity {
    return .init(
      id: uid,
      nickname: nickname,
      profileImageUrl: profileImagePath,
      profileImageData: profileData,
      isSavedProfileInServer: profileData != nil)
  }
}
