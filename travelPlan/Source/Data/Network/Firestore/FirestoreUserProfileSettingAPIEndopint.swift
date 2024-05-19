//
//  FirestoreUserProfileSettingAPIEndopint.swift
//  travelPlan
//
//  Created by 양승현 on 4/25/24.
//

import Foundation

struct FirestoreUserProfileSettingAPIEndopint {  
  static func saveUserProfileEndpoint(
    with requestDTO: UserProfileSaveRequestDTO
  ) -> FirestoreEndpoint<VoidResponseDTO> {
    return .init(
      requestDTO: requestDTO,
      method: .save(requestDTO.uid),
      requestType: .users(.userDocument(.saveUserProfile)))
  }
  
  static func makeNicknameIsDuplicatedEndpoint(
  ) -> FirestoreEndpoint<Bool> {
    return FirestoreEndpoint(
      method: .query,
      requestType: .users(.userDocument(.isNameDuplicated)))
  }
  
  static func makeNicknameUpdateEndpoint(
    ownerId: String,
    with requestDTO: UserNicknameRequestDTO
  ) -> FirestoreEndpoint<VoidResponseDTO> {
    return FirestoreEndpoint(
      requestDTO: requestDTO,
      method: .update,
      requestType: .users(.userDocument(.updateName(ownerId))))
  }
  
  static func makeProfileImageUpdateEndpoint(
    ownerId: String,
    with profileImageUrl: String
  ) -> FirestoreEndpoint<VoidResponseDTO> {
    let requestDict = ["profileImagePath": profileImageUrl]
    return FirestoreEndpoint(
      requestDTODictionary: requestDict,
      method: .update,
      requestType: .users(.userDocument(.updateProfileImage(ownerId))))
  }
  
  /// RequestDict 타입은 다음과 같아야 합니다.[profileImagepath: ""]
  static func makeProfileImageDeleteEndpoint(
    ownerId: String
  ) -> FirestoreEndpoint<VoidResponseDTO> {
    let requestDict = ["profileImagepath": ""]
    return FirestoreEndpoint(
      requestDTODictionary: requestDict,
      method: .delete,
      requestType: .users(.userDocument(.deleteProfileImagePath(ownerId))))
  }
}
