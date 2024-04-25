//
//  FirestoreUserAPIEndopint.swift
//  travelPlan
//
//  Created by 양승현 on 4/25/24.
//

import Foundation

struct VoidResponseDTO: Decodable { }

struct FirestoreUserAPIEndopint {
  static func fetchUserEndpoint(userUID: String) -> FirestoreEndpoint<VoidResponseDTO> {
    return .init(
      method: .get,
      requestType: .users(.userDocument(.user(userUID))))
  }
}
