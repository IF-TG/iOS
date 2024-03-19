//
//  DefaultLoggedInUserUseCase.swift
//  travelPlan
//
//  Created by 양승현 on 3/19/24.
//

import Foundation

final class DefaultLoggedInUserUseCase: LoggedInUserUseCase {
  // MARK: - Dependencies
  let loggedInUserRepository: LoggedInUserRepository
  
  // MARK: - Properties
  var nickname: String? {
    loggedInUserRepository.nickname
  }
  
  var profileURL: String? {
    loggedInUserRepository.profileURL
  }
  
  var isSavedProfileInServer: Bool {
    loggedInUserRepository.isSavedProfileInServer
  }
  
  var id: Int64? {
    loggedInUserRepository.id
  }
  
  var user: UserEntity? {
    loggedInUserRepository.user
  }
  
  // MARK: - Lifecycle
  init(loggedInUserRepository: LoggedInUserRepository) {
    self.loggedInUserRepository = loggedInUserRepository
  }
  
  // MARK: - Helpers
  func setUser(with userInfo: UserEntity) {
    loggedInUserRepository.setUser(with: userInfo)
  }
  
  func updateNickname(with nickname: String) -> Bool {
    return loggedInUserRepository.updateNickname(with: nickname)
  }
  
  func updateProfileURL(with url: String) -> Bool {
    return loggedInUserRepository.updateProfileURL(with: url)
  }
  
  func deleteProfile() -> Bool {
    return loggedInUserRepository.deleteProfile()
  }
}
