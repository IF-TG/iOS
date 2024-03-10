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
    method: .patch,
    parameters: [.query(requestDTO)],
    requestType: .userNameDuplicateCheck)
  }
}

/// About profile CRUD
/// 이미 디비에 존재하는 프로필에 save호출 시 서버에 중복 저장 될 수 있습니다.
extension UserInfoAPIEndpoint {
  static func updateProfile(
    withQuery queryRequestDTO: UserIdReqeustDTO,
    body bodyReqeustDTO: UserProfileRequestDTO
  ) -> Endpoint<CommonDTO<UserProfileResponseDTO>> {
    return Endpoint<CommonDTO<UserProfileResponseDTO>>(
      scheme: "http",
      host: "localhost:8080",
      method: .put,
      parameters: [.query(queryRequestDTO), .body(bodyReqeustDTO)],
      requestType: .userProfileUpdate)
  }
  
  static func saveProfile(
    withQuery queryReqeustDTO: UserIdReqeustDTO,
    body bodyReqeustDTO: UserProfileRequestDTO
  ) -> Endpoint<CommonDTO<UserProfileResponseDTO>> {
    return Endpoint<CommonDTO<UserProfileResponseDTO>>(
      scheme: "http",
      host: "localhost:8080",
      method: .post,
      parameters: [.query(queryReqeustDTO), .body(bodyReqeustDTO)],
      requestType: .userProfileSave)
  }
  
  static func deleteProfile(
    with requestDTO: UserIdReqeustDTO
  ) -> Endpoint<CommonDTO<Bool>> {
    return Endpoint<CommonDTO<Bool>>(
      scheme: "http",
      host: "localhost:8080",
      method: .delete,
      parameters: [.query(requestDTO)],
      requestType: .userProfileDelete)
  }
  
  static func fetchProfile(
    with requestDTO: UserIdReqeustDTO
  ) -> Endpoint<CommonDTO<UserProfileResponseDTO>> {
    return Endpoint<CommonDTO<UserProfileResponseDTO>>(
      scheme: "http",
      host: "localhost:8080",
      method: .get,
      parameters: [.query(requestDTO)],
      requestType: .userProfileFetch)
  }
}
