//
//  StubOwnerStorage.swift
//  travelPlan
//
//  Created by 양승현 on 3/19/24.
//

import Foundation
import UIKit

final class StubOwnerStorage: OwnerStorage {
  func updateProfileImagePath(with imagePath: String) -> Bool {
    return true
  }
  
  var blockedUsers: [UserIdentifier] {
    []
  }
  
  func addBlockedUser(with userId: UserIdentifier) {}
  
  func deleteBlockedUser(with userId: UserIdentifier) {}
  
  func hasBlockedUser(with userId: UserIdentifier) -> Bool { return false }
  
  var nickname: String? {
    "난짱구"
  }
  
  var profileImageData: Data? {
    UIImage(named: "tempProfile3")?.jpegData(compressionQuality: 0.8)
  }
  
  var isSavedProfileInServer: Bool {
    false
  }
  
  var id: UserIdentifier? {
    11
  }
  
  var user: UserEntity? {
    .init(id: 1, nickname: "난짱구", profileImageUrl: "", isSavedProfileInServer: false)
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
