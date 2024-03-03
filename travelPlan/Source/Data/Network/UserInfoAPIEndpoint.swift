//
//  UserInfoAPIEndpoint.swift
//  travelPlan
//
//  Created by 양승현 on 2/27/24.
//

import Foundation

struct UserInfoAPIEndpoint {
  /// 사용자의 이름이 중복인지 확인할 때 사용합니다.
  static func checkIfNicknameDuplicate(
    with requestDTO: UserNicknameRequestDTO
  ) -> Endpoint<CommonDTO<Bool>> {
    return Endpoint<CommonDTO<Bool>>(
      scheme: "http",
      host: "localhost:8080",
      method: .get,
      parameters: [.query(requestDTO)],
      requestType: .userNameDuplicateCheck)
  }
  
  static func updateUserNickname(
    with requestDTO: UserNicknamePatchRequestDTO
  ) -> Endpoint<CommonDTO<Bool>> {
    return Endpoint<CommonDTO<Bool>>(
    scheme: "http",
    host: "localhost:8080",
    parameters: [.query(requestDTO)],
    requestType: .userNameDuplicateCheck)
  }
  
  static func updateProfile(
    withQuery queryRequestDTO: UserIdReqeustDTO,
    body bodyReqeustDTO: UserProfileRequestDTO
  ) -> Endpoint<CommonDTO<UserProfileResponseDTO>> {
    return Endpoint<CommonDTO<UserProfileResponseDTO>>(
      scheme: "http",
      host: "localhost:8080",
      method: .post,
      parameters: [.query(queryRequestDTO), .body(bodyReqeustDTO)],
      requestType: .userProfileUpdate)
  }
}
