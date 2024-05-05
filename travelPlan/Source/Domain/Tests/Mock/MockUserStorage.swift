//
//  MockUserStorage.swift
//  travelPlan
//
//  Created by 양승현 on 3/19/24.
//

import Foundation
import UIKit

final class MockUserStorage: OwnerStorage {
  var blockedUsers: [BlockedUserId] {
    []
  }
  
  func addBlockedUser(with userId: String) {}
  
  func deleteBlockedUser(with userId: String) {}
  
  var nickname: String? {
    "짱구"
  }
  
  var profileImageData: Data? {
    UIImage(named: "tempProfile3")?.jpegData(compressionQuality: 0.8)
  }
  
  var isSavedProfileInServer: Bool {
    false
  }
  
  var id: String? {
    "sUSkn1ogJ5azdXaMYe0tt4sVJ8L2"
  }
  
  var user: UserEntity? {
    .init(id: "1", nickname: "짱구", isSavedProfileInServer: false)
  }
  
  func setUser(with userInfo: UserEntity) { }
  
  @discardableResult
  func updateNickname(with nickname: String) -> Bool {
    return true
  }
  
  @discardableResult
  func updateProfileImageData(with data: Data) -> Bool {
    return true
  }
  
  @discardableResult
  func deleteProfileImageData() -> Bool {
    return true
  }
}
