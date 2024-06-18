//
//  FirestoreUserProfileAPIEndpoint.swift
//  travelPlanTests
//
//  Created by 양승현 on 5/5/24.
//

import Foundation

struct FirestoreUserProfileAPIEndpoint {
  static func makeUserProfileFetchEndpoint(userUID: UserIdentifier) -> FirestoreEndpoint<UserProfileResponseDTO> {
    return .init(
      method: .get,
      requestType: .users(.userDocument(.fetchUserProfile(userUID))))
  }
}
