//
//  UserBlockAPIEndpoint.swift
//  travelPlan
//
//  Created by 양승현 on 4/1/24.
//

import Foundation

struct UserBlockAPIEndpoint {
  static func blockUser(
    with requestDTO: UserBlockRequestDTO
  ) -> Endpoint<CommonDTO<UserBlockResponseDTO>> {
    return Endpoint(
      scheme: "http",
      host: "localhost:8080",
      method: .post,
      parameters: [.body(requestDTO)],
      requestType: .user(.otherUserBlock(.userBlock)))
  }
  
  static func fetchBlockedUsers() -> Endpoint<CommonDTO<[BlockedUserProfileResponseDTO]>> {
    return Endpoint(
      scheme: "http",
      host: "localhost:8080",
      method: .get,
      parameters: nil,
      requestType: .user(.otherUserBlock(.blockedUsersFetch)))
  }
}
