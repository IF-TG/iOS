//
//  LoggedInUserRepository.swift
//  travelPlan
//
//  Created by 양승현 on 3/19/24.
//

import Foundation

@frozen enum LoggedInUserRepositoryError: LocalizedError {
  case invalidUserId
  
  var errorDescription: String? {
    switch self {
    case .invalidUserId:
      "로그인한 사용자의 아이디를 식별할 수 없습니다."
    }
  }
}

// TODO: - blockedUsers 추가하기
protocol LoggedInUserRepository {
  var nickname: String? { get }
  var profileImageData: Data? { get }
  var isSavedProfileInServer: Bool { get }
  var id: String? { get }
  var user: UserEntity? { get }
  var blockedUsers: [UserEntity] { get }
  
  func setUser(with userInfo: UserEntity)
  
  @discardableResult
  func updateNickname(with nickname: String) -> Bool
  
  @discardableResult
  func updateProfileImageData(with data: Data) -> Bool
  
  @discardableResult
  func deleteProfileImageData() -> Bool
}
