//
//  LoginAPIEndPoints.swift
//  travelPlan
//
//  Created by SeokHyun on 2/29/24.
//

import Foundation

struct LoginAPIEndPoints {
  static func getAppleAuthToken(requestDTO body: LoginRequestDTO) -> Endpoint<LoginResponseDTO> {
    return Endpoint<LoginResponseDTO>(
      host: "미정",
      method: .post,
      prefixPath: "미정",
      parameters: body,
      requestType: .none
    )
  }
}
