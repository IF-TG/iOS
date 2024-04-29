//
//  FirestorePostAPIEndpoint.swift
//  travelPlan
//
//  Created by 양승현 on 4/29/24.
//

import Foundation

struct FirestorePostAPIEndpoint {
  static func fetchPostsEndpoint(
    with requestDTO: PostsRequestDTO
  ) -> FirestoreEndpoint<[PostResponseDTO]> {
    return .init(
      requestDTO: requestDTO,
      method: .query,
      requestType: .posts(.fetch))
  }
}
