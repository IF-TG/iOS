//
//  LoginResponseDTO.swift
//  travelPlan
//
//  Created by SeokHyun on 2/29/24.
//

import Foundation

struct LoginResponseDTO: Decodable {
  let accessToken: String
  let refreshToken: String
}
