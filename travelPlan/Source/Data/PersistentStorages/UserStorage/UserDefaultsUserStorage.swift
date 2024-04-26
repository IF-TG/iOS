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
      let userData = UserDefaultsManager[.user] as? Data,
      let user = decode(with: userData)
    else { return nil }
    return user
  }
  
  func setUser(with userInfo: UserEntity) {
    backgroundQueue.async { [weak self] in
      userDefaults[.user] = self?.encode(from: userInfo)
    }
  }
  
  func updateNickname(with nickname: String) -> Bool {
    guard var user = user else {
      os_log("DEBUG: 사용자의 이름이 저장되지 않았습니다.", log: OSLog.default, type: .error)
      return false
    }
    backgroundQueue.async { [weak self] in
      user.nickname = nickname
      UserDefaultsManager[.user] = self?.encode(from: user)
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
      UserDefaultsManager[.user] = self?.encode(from: user)
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
      UserDefaultsManager[.user] = self?.encode(from: user)
    }
    return true
  }
}

// MARK: - Private Helpers
extension UserDefaultsUserStorage {
  func encode(from userEntity: UserEntity) -> Data? {
    guard let encodedData = try? JSONEncoder().encode(user) else {
      os_log("DEBUG: 사용자 엔터티가 인코딩되지 않았습니다.", log: OSLog.default, type: .error)
      return nil
    }
    return encodedData
  }
  
  func decode(with userData: Data) -> UserEntity? {
    guard let entity = try? JSONDecoder().decode(UserEntity.self, from: userData) else {
      os_log("DEBUG: 사용자 데이터가 디코딩 되지 않았습니다.", log: OSLog.default, type: .error)
      return nil
    }
    return entity
  }
}
