//
//  LoginKeychainStorage.swift
//  travelPlan
//
//  Created by SeokHyun on 3/14/24.
//

import Foundation

protocol LoginKeychainStorage {
  func saveTokens(jwtDTO: JWTResponseDTO) -> Bool
}
