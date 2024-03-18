//
//  JWTResponseDTO.swift
//  travelPlan
//
//  Created by SeokHyun on 3/13/24.
//

import Foundation

struct JWTResponseDTO: Decodable {
  let accessToken: String
  let refreshToken: String
  let accessTokenExpiresIn: Double
  let refreshTokenExpiresIn: Double
}
