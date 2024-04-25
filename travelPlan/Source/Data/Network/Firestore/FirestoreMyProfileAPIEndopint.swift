//
//  FirestoreMyProfileAPIEndopint.swift
//  travelPlan
//
//  Created by 양승현 on 4/25/24.
//

import Foundation

struct FirestoreMyProfileAPIEndopint {
  static func fetchUserProfileEndpoint(userUID: String) -> FirestoreEndpoint<UserProfileResponseDTO> {
    return .init(
      method: .get,
      requestType: .users(.userDocument(.fetchUserProfile(userUID))))
  }
  
  static func saveUserProfileEndpoint(
    with requestDTO: UserProfileSaveRequestDTO
  ) -> FirestoreEndpoint<VoidResponseDTO> {
    return .init(
      requestDTO: requestDTO,
      method: .save,
      requestType: .users(.userDocument(.saveUserProfile)))
  }
}
