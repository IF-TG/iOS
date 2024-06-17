//
//  OwnerStorage.swift
//  travelPlan
//
//  Created by 양승현 on 3/19/24.
//

import Foundation

protocol OwnerStorage {
  var nickname: String? { get }
  var profileImageData: Data? { get }
  var isSavedProfileInServer: Bool { get }
  var id: UserIdentifier? { get }
  var user: UserEntity? { get }
  var blockedUsers: [UserIdentifier] { get }
  
  func setUser(with userInfo: UserEntity)
  
  func addBlockedUser(with userId: UserIdentifier)
  
  func deleteBlockedUser(with userId: UserIdentifier)
  
  func hasBlockedUser(with userId: UserIdentifier) -> Bool
  
  @discardableResult
  func updateNickname(with nickname: String) -> Bool
  
  @discardableResult
  func updateProfileImagePath(with imagePath: String) -> Bool
  
  @discardableResult
  func updateProfileImageData(with data: Data) -> Bool
  
  @discardableResult
  func deleteProfileImageData() -> Bool
}
