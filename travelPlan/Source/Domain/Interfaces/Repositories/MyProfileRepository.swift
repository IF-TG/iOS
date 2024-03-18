//
//  MyProfileRepository.swift
//  travelPlan
//
//  Created by 양승현 on 2/27/24.
//

import Foundation
import Combine

enum MyProfileRepositoryError: LocalizedError {
  case invaildUserId
  case networkError(ConnectionError)
  case unknown(description: String)
}

/// 사용자 정보 CRUD 관련 레포지토리
protocol MyProfileRepository {
  func checkIfUserNicknameDuplicate(with name: String) -> Future<Bool, MyProfileRepositoryError>
  func updateUserNickname(with name: String) -> Future<Bool, MyProfileRepositoryError>
  func updateProfile(with profile: String) -> Future<Bool, MyProfileRepositoryError>
  func saveProfile(with profile: String) -> Future<Bool, MyProfileRepositoryError>
  func deleteProfile() -> Future<Bool, MyProfileRepositoryError>
  func fetchProfile() -> Future<ProfileImageEntity, MyProfileRepositoryError>
  var isProfileSavedInServer: Bool { get }
}
