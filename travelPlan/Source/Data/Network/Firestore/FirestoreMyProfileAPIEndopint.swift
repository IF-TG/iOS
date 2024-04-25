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
      requestType: .users(.userDocument(.user(userUID))))
  }
}
