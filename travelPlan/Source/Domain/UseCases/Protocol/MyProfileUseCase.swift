//
//  MyProfileUseCase.swift
//  travelPlan
//
//  Created by 양승현 on 2/27/24.
//

import Combine
import Foundation

enum MyProfileUseCaseError: LocalizedError {
  case invalidUserId
  case networkError(ConnectionError)
  case unknown(String)
  
  var errorDescription: String? {
    switch self {
    case .invalidUserId:
      NSLocalizedString("로그인한 사용자의 정보가 유효하지 않습니다.", comment: "")
    case .networkError(let connectionError):
      connectionError.errorDescription
    case .unknown(let errorDescription):
      NSLocalizedString(errorDescription, comment: "")
    }
  }
}

protocol MyProfileUseCase {
  var isProfileSavedInServer: Bool { get }
  
  func checkIfNicknameDuplicate(with name: String) -> AnyPublisher<Bool, Error>
  func updateNickname(with name: String) -> AnyPublisher<Bool, Error>
  func updateProfile(with base64String: String) -> AnyPublisher<Bool, Error>
  func saveProfile(with base64String: String) -> AnyPublisher<Bool, Error>
  func deleteProfile() -> AnyPublisher<Bool, Error>
  func fetchProfile() -> AnyPublisher<ProfileImageEntity, Error>
}
