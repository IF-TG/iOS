//
//  UserInfoAPIEndpoint.swift
//  travelPlan
//
//  Created by 양승현 on 2/27/24.
//

import Foundation

struct UserInfoAPIEndpoint {
  private static let prefixPath = "profile"
  /// 사용자의 이름이 중복인지 확인할 때 사용합니다.
  static func checkIfNicknameDuplicate(
    with requestDTO: UserNicknameRequestDTO
  ) -> Endpoint<CommonDTO<Bool>> {
    return Endpoint<CommonDTO<Bool>>(
      scheme: "http",
      host: "localhost:8080",
      method: .get,
      prefixPath: "",
      parameters: requestDTO,
      requestType: .userNameDuplicateCheck)
  }
  
  static func updateUserNickname(
    with requestDTO: UserNicknamePatchRequestDTO
  ) -> Endpoint<CommonDTO<Bool>> {
    return Endpoint<CommonDTO<Bool>>(
    scheme: "http",
    host: "localhost:8080",
    prefixPath: "",
    parameters: requestDTO,
    requestType: .userNameDuplicateCheck)
  }
  
  static func updateProfile(
    with requestDTO: UserProfileRequestDTO
  ) -> Endpoint<CommonDTO<UserProfileResponseDTO>> {
    return Endpoint<CommonDTO<UserProfileResponseDTO>>(
      scheme: "http",
      host: "localhost:8080",
      method: .put,
      prefixPath: prefixPath,
      parameters: requestDTO,
      requestType: .userProfileUpdate)
  }
}
