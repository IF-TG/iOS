//
//  FavoritePostAPIEndpoint.swift
//  travelPlan
//
//  Created by 양승현 on 4/4/24.
//

import Foundation

struct FavoritePostAPIEndpoint {
  static func fetchFavoritePosts(
    with requestDTO: FavoritePostRequestDTO
  ) -> Endpoint<CommonDTO<[PostResponseDTO]>> {
    return Endpoint(
      scheme: "http",
      host: "localhost:8080",
      method: .get,
      parameters: [.query(requestDTO)],
      requestType: .favoritePostInDirectory(.favoritePostsFetch))
  }
}
