//
//  FirestorePostAPIEndpoint.swift
//  travelPlan
//
//  Created by 양승현 on 4/29/24.
//

import Foundation

struct FirestorePostAPIEndpoint {
  static func fetchPostsEndpoint() -> FirestoreEndpoint<[PostResponseDTO]> {
    return .init(
      requestDTO: nil,
      method: .query,
      requestType: .posts(.fetch))
  }
}
