//
//  LoggedInUserUseCase.swift
//  travelPlan
//
//  Created by 양승현 on 3/19/24.
//

import Foundation

protocol LoggedInUserUseCase {
  var nickname: String? { get }
  var profileImageData: Data? { get }
  var isSavedProfileInServer: Bool { get }
  var id: String? { get }
  var user: UserEntity? { get }
  
  func setUser(with userInfo: UserEntity)
  
  @discardableResult
  func updateNickname(with nickname: String) -> Bool
  
  @discardableResult
  func updateProfileImageData(with url: Data) -> Bool
  
  @discardableResult
  func deleteProfileImageData() -> Bool

}
