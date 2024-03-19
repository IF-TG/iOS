//
//  MockUserStorage.swift
//  travelPlan
//
//  Created by 양승현 on 3/19/24.
//

import Foundation

final class MockUserStorage: UserStorage {
  var nickname: String? {
    "짱구"
  }
  
  var profileURL: String? {
    "bieiofhwnkslkh39f2i"
  }
  
  var isSavedProfileInServer: Bool {
    false
  }
  
  var id: Int64? {
    1
  }
  
  var user: UserEntity? {
    .init(id: 1, nickname: "짱구", isSavedProfileInServer: false)
  }
  
  func setUser(with userInfo: UserEntity) { }
  
  @discardableResult
  func updateNickname(with nickname: String) -> Bool {
    return true
  }
  
  @discardableResult
  func updateProfileURL(with url: String) -> Bool {
    return true
  }
  
  @discardableResult
  func deleteProfile() -> Bool {
    return true
  }
}
