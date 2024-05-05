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
  let storage: OwnerStorage
  
  // MARK: - Properties
  var nickname: String? {
    storage.nickname
  }
  
  var profileImageData: Data? {
    storage.profileImageData
  }
  
  var isSavedProfileInServer: Bool {
    storage.isSavedProfileInServer
  }
  
  var id: String? {
    storage.id
  }
  
  var user: UserEntity? {
    storage.user
  }
  
  // MARK: - Lifecycle
  init(storage: OwnerStorage) {
    self.storage = storage
  }
  
  // MARK: - Helpers
  func setUser(with userInfo: UserEntity) {
    storage.setUser(with: userInfo)
  }
  
  @discardableResult
  func updateNickname(with nickname: String) -> Bool {
    storage.updateNickname(with: nickname)
  }
  
  @discardableResult
  func updateProfileImageData(with data: Data) -> Bool {
    storage.updateProfileImageData(with: data)
  }
  
  @discardableResult
  func deleteProfileImageData() -> Bool {
    storage.deleteProfileImageData()
  }
}
