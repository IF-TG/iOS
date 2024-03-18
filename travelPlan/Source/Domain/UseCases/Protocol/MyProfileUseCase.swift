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
  
  var errorDescription: String? {
    switch self {
    case .invalidUserId:
      NSLocalizedString("로그인 정보가 유효하지 않습니다.", comment: "")
    case .networkError(let connectionError):
      connectionError.errorDescription
    }
  }
}

protocol MyProfileUseCase {
  var isNicknameDuplicated: PassthroughSubject<Bool, Error> { get }
  var isNicknameUpdated: PassthroughSubject<Bool, Error> { get }
  var isProfileUpdated: PassthroughSubject<Bool, Error> { get }
  var isProfileSaved: PassthroughSubject<Bool, Error> { get }
  var isProfileDeleted: PassthroughSubject<Bool, Error> { get }
  var fetchedProfile: PassthroughSubject<ProfileImageEntity, Error> { get }
  var isProfileSavedInServer: Bool { get }
  
  func checkIfNicknameDuplicate(with name: String)
  func updateNickname(with name: String)
  func updateProfile(with base64String: String)
  func saveProfile(with base64String: String)
  func deleteProfile()
  func fetchProfile()
}
