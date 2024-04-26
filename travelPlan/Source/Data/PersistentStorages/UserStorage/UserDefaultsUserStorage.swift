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
    case profileImageData
    case isSavedProfileInServer
  }
  
  // MARK: - Properties
  private typealias userDefaults = UserDefaultsManager
  
  private let backgroundQueue: DispatchQueue
  
  init(backgroundQueue: DispatchQueue = DispatchQueue.global(qos: .userInitiated)) {
    self.backgroundQueue = backgroundQueue
  }
}

// MARK: - UserStorage
extension UserDefaultsUserStorage: UserStorage {
  var nickname: String? {
    user?.nickname
  }
  
  var profileImageData: Data? {
    user?.profileImageData
  }
  
  var isSavedProfileInServer: Bool {
    guard user?.profileImageData == nil else {
      return true
    }
    return false
  }
  
  var id: String? {
    user?.id
  }
  
  var user: UserEntity? {
    guard
      let user = UserDefaultsManager[.user] as? [String: Any],
      let id = user[Key.id.rawValue] as? String,
      let nickname = user[Key.nickname.rawValue] as? String,
      let isSavedProfileInServer = user[Key.isSavedProfileInServer.rawValue] as? Bool
    else { return nil }
    let profileURL = user[Key.profileImageData.rawValue] as? String
    return UserEntity(
      id: id,
      nickname: nickname,
      profileImageData: profileImageData,
      isSavedProfileInServer: isSavedProfileInServer)
  }
  
  func setUser(with userInfo: UserEntity) {
    backgroundQueue.async { [weak self] in
      userDefaults[.user] = self?.convertToDictionary(from: userInfo)
    }
  }
  
  func updateNickname(with nickname: String) -> Bool {
    guard var user = user else {
      os_log("DEBUG: 사용자의 이름이 저장되지 않았습니다.", log: OSLog.default, type: .error)
      return false
    }
    backgroundQueue.async { [weak self] in
      user.nickname = nickname
      let userDict = self?.convertToDictionary(from: user)
      UserDefaultsManager[.user] = userDict
    }
    return true
  }
  
  func updateProfileImageData(with data: Data) -> Bool {
    guard var user = user else {
      os_log("DEBUG: 사용자의 프로필이 저장되지 않았습니다.", log: OSLog.default, type: .error)
      return false
    }
    backgroundQueue.async { [weak self] in
      user.profileImageData = data
      let userDict = self?.convertToDictionary(from: user)
      UserDefaultsManager[.user] = userDict
    }
    return true
  }
  
  func deleteProfileImageData() -> Bool {
    guard var user = user else {
      os_log("DEBUG: 사용자의 프로필이 저장되지 않았습니다.", log: OSLog.default, type: .error)
      return false
    }
    backgroundQueue.async { [weak self] in
      user.profileImageData = nil
      let userDict = self?.convertToDictionary(from: user)
      UserDefaultsManager[.user] = userDict
    }
    return true
  }
}

// MARK: - Private Helpers
extension UserDefaultsUserStorage {
  func convertToDictionary(from user: UserEntity) -> [String: Any?] {
    return [
      Key.id.rawValue: user.id,
      Key.nickname.rawValue: user.nickname,
      Key.profileImageData.rawValue: user.profileImageData,
      Key.isSavedProfileInServer.rawValue: user.isSavedProfileInServer]
  }
}
