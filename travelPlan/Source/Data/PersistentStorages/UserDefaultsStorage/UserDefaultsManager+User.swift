//
//  UserDefaultsManager+User.swift
//  travelPlan
//
//  Created by 양승현 on 3/12/24.
//

import Foundation

// MARK: - Nested
extension UserDefaultsManager.Key {
  enum User: String {
    case id
    case nickname
    case profileURL
    case isSavedProfile
  }
}

// MARK: - Utils
extension UserDefaultsManager {
  static func convertToDictionary(from user: UserEntity) -> [String: Any] {
    return [
      Key.User.id.rawValue: user.id,
      Key.User.nickname.rawValue: user.nickname,
      Key.User.profileURL.rawValue: user.profileURL ?? "",
      Key.User.isSavedProfile.rawValue: user.isSavedProfile]
  }
}

// MARK: - CRUD Helpers
extension UserDefaultsManager {
  static func setUser(with user: UserEntity) {
    UserDefaultsManager[.user] = convertToDictionary(from: user)
  }
  
  static var userNickname: String? {
    user?.nickname
  }
  
  static var userProfileURL: String? {
    user?.profileURL
  }
  
  static var user: UserEntity? {
    guard
      let user = UserDefaultsManager[.user] as? [String: Any],
      let id = user[Key.User.id.rawValue] as? String,
      let nickname = user[Key.User.nickname.rawValue] as? String,
      let isSavedProfile = user[Key.User.isSavedProfile.rawValue] as? Bool
    else { return nil }
    let profileURL = user[Key.User.profileURL.rawValue] as? String
    return UserEntity(
      id: id,
      nickname: nickname,
      profileURL: profileURL,
      isSavedProfile: isSavedProfile)
  }
  
  @discardableResult
  static func updateUserProfile(with url: String) -> Bool {
    guard var user = user else { return false }
    user.profileURL = url
    let userDict = convertToDictionary(from: user)
    UserDefaultsManager[.user] = userDict
    return true
  }
  
  @discardableResult
  static func updateUserNickname(with nickname: String) -> Bool {
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
  static func updateUserProfileURL(with url: String) -> Bool {
    guard var user = user else {
      print("DEBUG: 사용자의 프로필이 저장되지 않았습니다.")
      return false
    }
    user.profileURL = url
    let userDict = convertToDictionary(from: user)
    UserDefaultsManager[.user] = userDict
    return true
  }
}
