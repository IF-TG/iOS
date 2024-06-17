//
//  DefaultLoggedInUserRepository.swift
//  travelPlan
//
//  Created by 양승현 on 3/19/24.
//

import Foundation

/// UserStorage에서 로그인한 사용자 데이터를 가져옵니다.
final class DefaultLoggedInUserRepository: LoggedInUserRepository {
  // MARK: - Dependencies
  let storage: Dependency<OwnerStorage>
  
  // MARK: - Properties
  var nickname: String? {
    storage.wrappedValue.nickname
  }
  
  var profileImageData: Data? {
    storage.wrappedValue.profileImageData
  }
  
  var isSavedProfileInServer: Bool {
    storage.wrappedValue.isSavedProfileInServer
  }
  
  var id: UserIdentifier? {
    storage.wrappedValue.id
  }
  
  var user: UserEntity? {
    storage.wrappedValue.user
  }
  
  var blockedUsers: [UserIdentifier] {
    storage.wrappedValue.blockedUsers
  }
  
  // MARK: - Lifecycle
  init(storage: Dependency<OwnerStorage>) {
    self.storage = storage
  }
  
  // MARK: - Helpers
  func setUser(with userInfo: UserEntity) {
    storage.wrappedValue.setUser(with: userInfo)
  }
  
  func hasBlockedUser(with userId: UserIdentifier) -> Bool {
    storage.wrappedValue.hasBlockedUser(with: userId)
  }
  
  func addBlockedUser(with userId: UserIdentifier) {
    storage.wrappedValue.addBlockedUser(with: userId)
  }
  
  func deleteBlockedUser(with userId: UserIdentifier) {
    storage.wrappedValue.deleteBlockedUser(with: userId)
  }
  
  @discardableResult
  func updateNickname(with nickname: String) -> Bool {
    storage.wrappedValue.updateNickname(with: nickname)
  }
  
  @discardableResult
  func updateProfileImageData(with data: Data) -> Bool {
    storage.wrappedValue.updateProfileImageData(with: data)
  }
  
  @discardableResult
  func deleteProfileImageData() -> Bool {
    storage.wrappedValue.deleteProfileImageData()
  }
}
