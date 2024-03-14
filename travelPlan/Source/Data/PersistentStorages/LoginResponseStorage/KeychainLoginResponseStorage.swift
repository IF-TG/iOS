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
      convertToData(for: makeTokenDeadlineSec(token: jwtDTO.accessTokenExpiresIn)),
      convertToData(for: makeTokenDeadlineSec(token: jwtDTO.refreshTokenExpiresIn))
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
  private func makeTokenDeadlineSec(token: Int) -> TimeInterval {
    return TimeInterval(token) + Date().timeIntervalSince1970
  }
  
  private func convertToData(for value: Double) -> Data {
    return withUnsafeBytes(of: value) { Data($0) }
  }
}
