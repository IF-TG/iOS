//
//  DefaultMyProfileUseCase.swift
//  travelPlan
//
//  Created by 양승현 on 2/27/24.
//

import Foundation
import Combine

final class DefaultMyProfileUseCase: MyProfileUseCase {
  // MARK: - Dependencies
  private let myProfileRepository: MyProfileRepository
  
  // MARK: - Properties
  var subscription: AnyCancellable?
  
  var isProfileSavedInServer: Bool {
    myProfileRepository.isProfileSavedInServer
  }
  
  private var subscriptions = Set<AnyCancellable>()
  
  // MARK: - Lifecycle
  init(myProfileRepository: MyProfileRepository) {
    self.myProfileRepository = myProfileRepository
  }
  
  func checkIfNicknameDuplicate(with name: String) -> AnyPublisher<Bool, any Error> {
    return myProfileRepository.checkIfUserNicknameDuplicate(with: name)
      .mapError { $0 }
      .eraseToAnyPublisher()
  }
  
  func updateNickname(with name: String) -> AnyPublisher<Bool, Error> {
    return myProfileRepository.updateUserNickname(with: name)
      .mapError { $0 }
      .eraseToAnyPublisher()
  }
  
  func updateProfile(with base64String: String) -> AnyPublisher<Bool, Error> {
    return myProfileRepository.updateProfileImage(with: base64String)
      .mapError { $0 }
      .eraseToAnyPublisher()
  }
  
  func saveProfile(with base64String: String) -> AnyPublisher<Bool, Error> {
    return myProfileRepository.saveProfileImage(with: base64String)
      .mapError { $0 }
      .eraseToAnyPublisher()
  }
  
  func deleteProfile() -> AnyPublisher<Bool, Error> {
    myProfileRepository.deleteProfileImage()
      .mapError { $0 }
      .eraseToAnyPublisher()
  }
  
  func fetchProfile() -> AnyPublisher<ProfileImageEntity, any Error> {
    myProfileRepository.fetchProfileImage()
      .mapError { $0 }
      .eraseToAnyPublisher()
  }
}
