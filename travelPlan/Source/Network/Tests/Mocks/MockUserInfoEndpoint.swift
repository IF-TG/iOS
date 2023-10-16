//
//  MockUserInfoEndpoint.swift
//  travelPlan
//
//  Created by 양승현 on 10/16/23.
//

final class MockUserInfoEndpoint {
  static let shared = MockUserInfoEndpoint()
  
  func uploadUserName(
    with requestDTO: UserNameRequestDTO
  ) -> Endpoint<UserNameResponseDTO> {
    return Endpoint(
      scheme: "https",
      host: "test.com",
      method: .post,
      prefixPath: "/user",
      parameters: requestDTO,
      requestType: .none)
  }
}
