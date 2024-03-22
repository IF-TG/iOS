//
//  UserStorage.swift
//  travelPlan
//
//  Created by 양승현 on 3/19/24.
//

import Foundation

protocol UserStorage {
  var nickname: String? { get }
  var profileURL: String? { get }
  var isSavedProfileInServer: Bool { get }
  var id: Int64? { get }
  var user: UserEntity? { get }
  
  func setUser(with userInfo: UserEntity)
  
  @discardableResult
  func updateNickname(with nickname: String) -> Bool
  
  @discardableResult
  func updateProfileURL(with url: String) -> Bool
  
  @discardableResult
  func deleteProfile() -> Bool
}
