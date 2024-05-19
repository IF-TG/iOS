//
//  UserDefaultsOwnerStorage.swift
//  travelPlan
//
//  Created by 양승현 on 3/19/24.
//

import Foundation
import OSLog

/// 로그인한 사용자의 정보를 디바이스 파일에 관리하는 객체힙니다.
final class UserDefaultsOwnerStorage {
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

// MARK: - OwnerStorage
extension UserDefaultsOwnerStorage: OwnerStorage {
  var blockedUsers: [BlockedUserId] {
    guard let blockedUsers = UserDefaultsManager[.blockedUsers] as? [String] else {
      return []
    }
    return blockedUsers
  }
  
  func hasBlockedUser(with userId: BlockedUserId) -> Bool {
    return blockedUsers.contains(where: { blockedUser in
      return blockedUser == userId
    })
  }
  
  func addBlockedUser(with userId: BlockedUserId) {
    backgroundQueue.async {
      var blockedUserList = userDefaults[.blockedUsers] as? [String] ?? []
      blockedUserList.append(userId)
      userDefaults[.blockedUsers] = blockedUserList
    }
  }
  
  func deleteBlockedUser(with userId: BlockedUserId) {
    backgroundQueue.async {
      var blockedUserList = userDefaults[.blockedUsers] as? [String] ?? []
      if let blockedUserIndex = blockedUserList.firstIndex(of: userId) {
        blockedUserList.remove(at: blockedUserIndex)
      }
      userDefaults[.blockedUsers] = blockedUserList
    }
  }
  
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
  
  // TODO: - 로직 잘못됨. async await 쓰거나 COmbine쓰거나 @escaping ㅋㅋ
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
  
  func updateProfileImagePath(with imagePath: String) -> Bool {
    guard var user = user else {
      os_log("DEBUG: 사용자의 이름이 저장되지 않았습니다.", log: OSLog.default, type: .error)
      return false
    }
    backgroundQueue.async { [weak self] in
      user.profileImageUrl = imagePath
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
extension UserDefaultsOwnerStorage {
  func encode(from userEntity: UserEntity) -> Data? {
    guard let encodedData = try? JSONEncoder().encode(userEntity) else {
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
