//
//  FirestorePostAPIEndpoint.swift
//  travelPlan
//
//  Created by 양승현 on 4/29/24.
//

import Foundation

struct FirestorePostAPIEndpoint {
  static func fetchPostsEndpoint() -> FirestoreEndpoint<FirestorePostResponseDTO> {
    return .init(
      requestDTO: nil,
      method: .query,
      requestType: .posts(.fetch))
  }
  
  static func fetchSpecificPostEndpoint(
    postId: String
  ) -> FirestoreEndpoint<FirestorePostResponseDTO> {
    return FirestoreEndpoint(method: .get, requestType: .posts(.fetchSpecificPost(postId: postId)))
  }
}
