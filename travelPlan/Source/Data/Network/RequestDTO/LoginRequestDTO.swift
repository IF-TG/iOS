//
//  LoginRequestDTO.swift
//  travelPlan
//
//  Created by SeokHyun on 2/29/24.
//

import Foundation

struct LoginRequestDTO: Encodable {
  let authorizationCode: String
  let identityToken: String
}
