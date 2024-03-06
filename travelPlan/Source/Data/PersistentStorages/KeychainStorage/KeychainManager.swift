//
//  KeychainManager.swift
//  travelPlan
//
//  Created by SeokHyun on 3/1/24.
//

import Foundation

class KeychainManager {
  // MARK: - Properties
  static let shared = KeychainManager()
  
  // MARK: - LifeCycle
  private init() { }
}

// MARK: - Helpers
extension KeychainManager {
  @discardableResult
  func add(key: String, value: Data?) -> Bool {
    let query: NSDictionary = [
      kSecClass: kSecClassGenericPassword,
      kSecAttrAccount: key,
      kSecValueData: value as Any
    ]
    let status = SecItemAdd(query, nil)
    guard status == errSecSuccess else {
      print("DEBUG: \(String(describing: SecCopyErrorMessageString(status, nil)))")
      return false
    }
    return true
  }
  
  /// load성공 시 Data? 타입을, 실패 시 nil을 반환합니다.
  func load(key: String) -> Data? {
    let query: NSDictionary = [
      kSecClass: kSecClassGenericPassword,
      kSecAttrAccount: key,
      kSecReturnData: kCFBooleanTrue!,
      kSecMatchLimit: kSecMatchLimitOne
    ]
    var item: CFTypeRef?
    let status = SecItemCopyMatching(query, &item)
    guard status == errSecSuccess, let data = item as? Data else {
      print("DEBUG: \(String(describing: SecCopyErrorMessageString(status, nil)))")
      return nil
    }
    return data
  }
  
  @discardableResult
  func update(key: String, value: Data?) -> Bool {
    let prevQuery: NSDictionary = [
      kSecClass: kSecClassGenericPassword,
      kSecAttrAccount: key
    ]
    let updateQuery: NSDictionary = [kSecValueData: value as Any]
    let status = SecItemUpdate(prevQuery, updateQuery)
    guard status == errSecSuccess else {
      print("DEBUG: \(String(describing: SecCopyErrorMessageString(status, nil)))")
      return false
    }
    return true
  }
  
  @discardableResult
  func delete(key: String) -> Bool {
    let query: NSDictionary = [
      kSecClass: kSecClassGenericPassword,
      kSecAttrAccount: key
    ]
    let status = SecItemDelete(query)
    guard status == errSecSuccess else {
      print("DEBUG: \(String(describing: SecCopyErrorMessageString(status, nil)))")
      return false
    }
    return true
  }
}
