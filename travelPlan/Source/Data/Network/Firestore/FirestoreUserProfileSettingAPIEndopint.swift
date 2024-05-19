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
}
