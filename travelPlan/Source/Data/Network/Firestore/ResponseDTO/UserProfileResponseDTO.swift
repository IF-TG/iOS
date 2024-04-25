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
  func toDomain() -> UserEntity {
    return .init(
      id: uid,
      nickname: nickname,
      profileURL: profileImagePath == "" ? nil : profileImagePath,
      isSavedProfileInServer: profileImagePath == "")
  }
}
