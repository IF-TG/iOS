//
//  DefaultKeyChainManager.swift
//  travelPlan
//
//  Created by SeokHyun on 3/3/24.
//

import Foundation

final class DefaultKeyChainManager: KeyChainManager {
  func addToken(_ token: String, forKey key: KeyChainKey) {
    let query: NSDictionary = [
      kSecClass: kSecClassGenericPassword,
      kSecAttrAccount: key.rawValue,
      kSecValueData: token.data(using: .utf8) as Any
    ]
    SecItemDelete(query)
    
    let status = SecItemAdd(query, nil)
    guard status == errSecSuccess else {
      print("DEBUG: KeyChain Error \(String(describing: SecCopyErrorMessageString(status, nil)))")
      return
    }
  }
  
  func deleteToken(forKey key: KeyChainKey) {
    let query: NSDictionary = [
      kSecClass: kSecClassGenericPassword,
      kSecAttrAccount: key.rawValue
    ]
    let status = SecItemDelete(query)
    guard status == errSecSuccess else {
      print("DEBUG: KeyChain Error \(String(describing: SecCopyErrorMessageString(status, nil)))")
      return
    }
  }
}

enum KeyChainKey: String {
  case accessToken
  case refreshToken
}
