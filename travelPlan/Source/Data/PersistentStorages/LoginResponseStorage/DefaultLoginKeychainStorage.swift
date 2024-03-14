//
//  DefaultLoginKeychainStorage.swift
//  travelPlan
//
//  Created by SeokHyun on 3/13/24.
//

import Foundation

final class DefaultLoginKeychainStorage {
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
    
    // 하나씩 저장을 하다가 하나라도 false이면 나머지 전부 제거
    for i in 0..<toSaveKeys.count {
      if !KeychainManager.shared.add(key: toSaveKeys[i], data: toSaveDatas[i]) {
        for j in 0..<i {
          KeychainManager.shared.delete(key: toSaveKeys[j])
        }
        return false
      }
    }
    return true
  }
}

// MARK: - Private Helpers
extension DefaultLoginKeychainStorage {
  private func makeTokenDeadlineSec(token: Int) -> TimeInterval {
    return TimeInterval(token) + Date().timeIntervalSince1970
  }
  
  private func convertToData(for value: Double) -> Data {
    return withUnsafeBytes(of: value) { Data($0) }
  }
}
/*
 // access token과 refresh token모두 저장한 적 없으면 저장하고 true
 access 만료시간이 갱신되거나 최초로 저장받으면, 시작 날짜 년월일시분초를 저장.
 앱 시작 시, 로그인을 했었는데 access 만료기간이 만료 되었으면 서버로부터 access와 refresh 다시 요청
 */
// 150
// 87100 + 150 = 87250 // 먼저 저장한값(당시 now + ExpiresIn)이 현재 값(now)보다 작으면 만료 안된 상태
// 88000

