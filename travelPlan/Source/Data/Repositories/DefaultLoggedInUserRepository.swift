//
//  DefaultLoggedInUserRepository.swift
//  travelPlan
//
//  Created by 양승현 on 3/19/24.
//

import Foundation

final class DefaultLoggedInUserRepository: LoggedInUserRepository {
  // MARK: - Dependencies
  let storage: UserStorage
  
  // MARK: - Properties
  var nickname: String? {
    storage.nickname
  }
  
  var profileURL: String?  {
    storage.profileURL
  }
  
  var isSavedProfileInServer: Bool {
    storage.isSavedProfileInServer
  }
  
  var id: Int64? {
    storage.id
  }
  
  var user: UserEntity? {
    storage.user
  }
  
  // MARK: - Lifecycle
  init(storage: UserStorage) {
    self.storage = storage
  }
  
  // MARK: - Helpers
  func setUser(with userInfo: UserEntity) {
    storage.setUser(with: userInfo)
  }
  
  func updateNickname(with nickname: String) -> Bool {
    storage.updateNickname(with: nickname)
  }
  
  func updateProfileURL(with url: String) -> Bool {
    storage.updateProfileURL(with: url)
  }
  
  func deleteProfile() -> Bool {
    storage.deleteProfile()
  }
}
