//
//  FirestorePostAPIEndpoint.swift
//  travelPlan
//
//  Created by 양승현 on 4/29/24.
//

import Foundation

struct FirestorePostAPIEndpoint {
  static func makePostsFetchEndpoint() -> FirestoreEndpoint<FirestorePostResponseDTO> {
    return .init(
      requestDTO: nil,
      method: .query,
      requestType: .posts(.fetch))
  }
  
  static func makeSpecificPostFetchEndpoint(
    postId: PostIdentifier
  ) -> FirestoreEndpoint<FirestorePostResponseDTO> {
    return FirestoreEndpoint(
      method: .get,
      requestType: .posts(.fetchSpecificPost(postId: postId)))
  }
}
