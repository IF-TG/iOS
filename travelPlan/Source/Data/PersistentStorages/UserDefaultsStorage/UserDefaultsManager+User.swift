//
//  UserDefaultsManager+User.swift
//  travelPlan
//
//  Created by 양승현 on 3/12/24.
//

import Foundation

// MARK: - Nested
extension UserDefaultsManager {
  struct User {
    enum Key: String {
      case id
      case nickname
      case profileURL
      case isSavedProfileInServer
    }
  }
}

// MARK: - Utils
extension UserDefaultsManager.User {
  static func convertToDictionary(from user: UserEntity) -> [String: Any] {
    return [
      Key.id.rawValue: user.id,
      Key.nickname.rawValue: user.nickname,
      Key.profileURL.rawValue: user.profileURL ?? "",
      Key.isSavedProfileInServer.rawValue: user.isSavedProfileInServer]
  }
}

// MARK: - CRUD Helpers
extension UserDefaultsManager.User {
  static var userNickname: String? {
    user?.nickname
  }
  
  static var userProfileURL: String? {
    user?.profileURL
  }
  
  static var isSavedProfileInserver: Bool {
    user?.isSavedProfileInServer ?? false
  }
  
  static var id: Int64? {
    user?.id
  }
  
  static var user: UserEntity? {
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
  
  static func setUser(with user: UserEntity) {
    UserDefaultsManager[.user] = convertToDictionary(from: user)
  }
  
  @discardableResult
  static func updateNickname(with nickname: String) -> Bool {
    guard var user = user else {
      print("DEBUG: 사용자의 이름이 저장되지 않았습니다.")
      return false
    }
    user.nickname = nickname
    let userDict = convertToDictionary(from: user)
    UserDefaultsManager[.user] = userDict
    return true
  }
  
  @discardableResult
  static func updateProfileURL(with url: String) -> Bool {
    guard var user = user else {
      print("DEBUG: 사용자의 프로필이 저장되지 않았습니다.")
      return false
    }
    user.profileURL = url
    let userDict = convertToDictionary(from: user)
    UserDefaultsManager[.user] = userDict
    return true
  }
  
  @discardableResult
  static func deleteProfile() -> Bool {
    guard var user = user else {
      print("DEBUG: 사용자의 프로필이 저장되지 않았습니다.")
      return false
    }
    user.profileURL = nil
    let userDict = convertToDictionary(from: user)
    UserDefaultsManager[.user] = userDict
    return true
  }
}
