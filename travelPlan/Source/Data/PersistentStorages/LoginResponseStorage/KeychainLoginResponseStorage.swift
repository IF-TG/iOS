//
//  KeychainLoginResponseStorage.swift
//  travelPlan
//
//  Created by SeokHyun on 3/13/24.
//

import Foundation

final class KeychainLoginResponseStorage {
  func saveTokens(jwtDTO: JWTResponseDTO) -> Bool {
    let toSaveKeys = [
      KeychainKey.accessToken.rawValue,
      KeychainKey.refreshToken.rawValue,
      KeychainKey.accessTokenDeadlineSec.rawValue,
      KeychainKey.refreshTokenDeadlineSec.rawValue
    ]
    let toSaveDatas = [
      jwtDTO.accessToken.data(using: .utf8),
      jwtDTO.refreshToken.data(using: .utf8),
      makeTokenDeadlineSec(tokenExpiresIn: jwtDTO.accessTokenExpiresIn).toData(),
      makeTokenDeadlineSec(tokenExpiresIn: jwtDTO.refreshTokenExpiresIn).toData()
    ]
    
    for i in 0..<toSaveKeys.count where !KeychainManager.shared.add(key: toSaveKeys[i], data: toSaveDatas[i]) {
      for j in 0..<i {
        KeychainManager.shared.delete(key: toSaveKeys[j])
      }
      return false
    }
    return true
  }
}

// MARK: - Private Helpers
extension KeychainLoginResponseStorage {
  private func makeTokenDeadlineSec(tokenExpiresIn: Double) -> TimeInterval {
    return TimeInterval(tokenExpiresIn / 1000) + Date().timeIntervalSince1970
  }
}
