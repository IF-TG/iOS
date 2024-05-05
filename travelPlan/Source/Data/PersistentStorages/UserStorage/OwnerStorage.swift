//
//  OwnerStorage.swift
//  travelPlan
//
//  Created by 양승현 on 3/19/24.
//

import Foundation

protocol OwnerStorage {
  typealias BlockedUserId = String
  
  var nickname: String? { get }
  var profileImageData: Data? { get }
  var isSavedProfileInServer: Bool { get }
  var id: String? { get }
  var user: UserEntity? { get }
  var blockedUsers : [BlockedUserId] { get }
  
  func setUser(with userInfo: UserEntity)
  
  func addBlockedUser(with userId: String)
  
  func deleteBlockedUser(with userId: String)
  
  @discardableResult
  func updateNickname(with nickname: String) -> Bool
  
  @discardableResult
  func updateProfileImageData(with data: Data) -> Bool
  
  @discardableResult
  func deleteProfileImageData() -> Bool
}
