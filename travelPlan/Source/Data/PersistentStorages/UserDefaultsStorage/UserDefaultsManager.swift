//
//  UserDefaultsManager.swift
//  travelPlan
//
//  Created by 양승현 on 3/12/24.
//

import Foundation

final class UserDefaultsManager {
  enum Key: String {
    case isLoggedIn
    case user
  }
  
  /// Key를 사용하지 않을 경우 subscript를 통해 직접 문자열로 UserDefaults에 저장할 수 있습니다.
  static subscript(_ key: Key) -> Any? {
    get {
      UserDefaults.standard.value(forKey: key.rawValue)
    } set {
      UserDefaults.standard.setValue(newValue, forKey: key.rawValue)
    }
  }
  
  static func delete(_ key: Key) {
    UserDefaults.standard.removeObject(forKey: key.rawValue)
  }
  
  static func boolValue(_ key: Key) -> Bool {
    if let value = UserDefaultsManager[key] as? Bool {
      return value
    }
    return false
  }
  
  static func stringValue(_ key: Key) -> String? {
    if let value = UserDefaultsManager[key] as? String {
      return value
    }
    return nil
  }
  
  static func intValue(_ key: Key) -> Int? {
    if let value = UserDefaultsManager[key] as? Int {
      return value
    }
    return nil
  }
}
