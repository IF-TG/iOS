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
  
  var profileImageData: Data? {
    loggedInUserRepository.profileImageData
  }
  
  var hasProfileImageSavedInServer: Bool {
    loggedInUserRepository.isSavedProfileInServer
  }
  
  var id: String? {
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
  
  @discardableResult
  func updateNickname(with nickname: String) -> Bool {
    return loggedInUserRepository.updateNickname(with: nickname)
  }
  
  @discardableResult
  func updateProfileImageData(with url: Data) -> Bool {
    return loggedInUserRepository.updateProfileImageData(with: url)
  }
  
  @discardableResult
  func deleteProfileImageData() -> Bool {
    return loggedInUserRepository.deleteProfileImageData()
  }
}
