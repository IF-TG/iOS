//
//  UserDefaultsUserStorage.swift
//  travelPlan
//
//  Created by 양승현 on 3/19/24.
//

import Foundation
import OSLog

final class UserDefaultsUserStorage {
  // MARK: - Nested
  enum Key: String {
    case id
    case nickname
    case profileURL
    case isSavedProfileInServer
  }
  
  // MARK: - Properties
  private typealias userDefaults = UserDefaultsManager
}

// MARK: - UserStorage
extension UserDefaultsUserStorage: UserStorage {

  var nickname: String? {
    user?.nickname
  }
  
  var profileURL: String? {
    user?.profileURL
  }
  
  var isSavedProfileInServer: Bool {
    guard user?.profileURL == nil else {
      return true
    }
    return false
  }
  
  var id: Int64? {
    user?.id
  }
  
  var user: UserEntity? {
    guard
      let user = UserDefaultsManager[.user] as? [String: Any],
      let id = user[Key.id.rawValue] as? Int64,
      let nickname = user[Key.nickname.rawValue] as? String,
      let isSavedProfileInServer = user[Key.isSavedProfileInServer.rawValue] as? Bool
    else { return nil }
    let profileURL = user[Key.profileURL.rawValue] as? String
    return UserEntity(
      id: id,
      nickname: nickname,
      profileURL: profileURL,
      isSavedProfileInServer: isSavedProfileInServer)
  }
  
  func setUser(with userInfo: UserEntity) {
    userDefaults[.user] = convertToDictionary(from: userInfo)
  }
  
  func updateNickname(with nickname: String) -> Bool {
    guard var user = user else {
      os_log("DEBUG: 사용자의 이름이 저장되지 않았습니다.", log: OSLog.default, type: .error)
      return false
    }
    user.nickname = nickname
    let userDict = convertToDictionary(from: user)
    UserDefaultsManager[.user] = userDict
    return true
  }
  
  func updateProfileURL(with url: String) -> Bool {
    guard var user = user else {
      os_log("DEBUG: 사용자의 프로필이 저장되지 않았습니다.", log: OSLog.default, type: .error)
      return false
    }
    user.profileURL = url
    let userDict = convertToDictionary(from: user)
    UserDefaultsManager[.user] = userDict
    return true
  }
  
  func deleteProfile() -> Bool {
    guard var user = user else {
      os_log("DEBUG: 사용자의 프로필이 저장되지 않았습니다.", log: OSLog.default, type: .error)
      return false
    }
    user.profileURL = nil
    let userDict = convertToDictionary(from: user)
    UserDefaultsManager[.user] = userDict
    return true
  }
}

// MARK: - Private Helpers
extension UserDefaultsUserStorage {
  func convertToDictionary(from user: UserEntity) -> [String: Any] {
    return [
      Key.id.rawValue: user.id,
      Key.nickname.rawValue: user.nickname,
      Key.profileURL.rawValue: user.profileURL ?? "",
      Key.isSavedProfileInServer.rawValue: user.isSavedProfileInServer]
  }
}
