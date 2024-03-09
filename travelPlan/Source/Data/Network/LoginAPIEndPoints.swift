//
//  LoginAPIEndPoints.swift
//  travelPlan
//
//  Created by SeokHyun on 2/29/24.
//

import Foundation

struct LoginAPIEndPoints {
  static func getAppleAuthToken(requestDTO body: LoginRequestDTO) -> Endpoint<CommonDTO<LoginResponseDTO>> {
    return Endpoint<CommonDTO<LoginResponseDTO>>(
      scheme: "https",
      host: "test.com",
      method: .post,
      parameters: [.body(body)],
      requestType: .custom("apple/login")
    )
  }
}
