//
//  MockUserEndpoint.swift
//  travelPlan
//
//  Created by 양승현 on 10/16/23.
//

@testable import travelPlan

final class MockUserEndpoint {
  private init() {}
  static let shared = MockUserEndpoint()
  
  func uploadUserName(
    with requestDTO: UserNameRequestDTO
  ) -> Endpoint<UserNameResponseDTO> {
    return Endpoint<UserNameResponseDTO>(
      scheme: "https",
      host: "test.com",
      method: .post,
      prefixPath: "/user",
      parameters: requestDTO,
      requestType: .custom("name-update"))
  }
}
