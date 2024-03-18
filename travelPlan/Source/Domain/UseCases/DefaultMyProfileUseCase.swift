//
//  DefaultMyProfileUseCase.swift
//  travelPlan
//
//  Created by 양승현 on 2/27/24.
//

import Foundation
import Combine

// MARK: - Publisher extension
private extension Publisher {
  func mapMyProfileUseCaseError<E>(
    _ transform: @escaping (Self.Failure) -> E
  ) -> Publishers.MapError<Self, Error> {
    return self.mapError { error -> Error in
      if let connectionError = error.asAFError?.mapConnectionError {
        return MyProfileRepositoryError.networkError(connectionError)
      }
      return MyProfileRepositoryError.unknown(description: error.localizedDescription)
    }
  }
}

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
    return myProfileRepository.updateProfile(with: base64String)
      .mapError { $0 }
      .eraseToAnyPublisher()
  }
  
  func saveProfile(with base64String: String) -> AnyPublisher<Bool, Error> {
    return myProfileRepository.saveProfile(with: base64String)
      .mapError { $0 }
      .eraseToAnyPublisher()
  }
  
  func deleteProfile() -> AnyPublisher<Bool, Error> {
    myProfileRepository.deleteProfile()
      .mapError { $0 }
      .eraseToAnyPublisher()
  }
  
  func fetchProfile() -> AnyPublisher<ProfileImageEntity, any Error> {
    myProfileRepository.fetchProfile()
      .mapError { $0 }
      .eraseToAnyPublisher()
  }
}
