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
  func checkIfUserNicknameDuplicate(with name: String) -> AnyPublisher<Bool, Error>
  func updateUserNickname(with name: String) -> AnyPublisher<Bool, Error>
  func updateProfile(with profile: String) -> AnyPublisher<Bool, Error>
  func saveProfile(with profile: String) -> AnyPublisher<Bool, Error>
  func deleteProfile() -> AnyPublisher<Bool, Error>
  func fetchProfile() -> AnyPublisher<ProfileImageEntity, Error>
  var isProfileSavedInServer: Bool { get }
}
