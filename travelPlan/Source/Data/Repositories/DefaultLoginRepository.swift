//
//  DefaultLoginRepository.swift
//  travelPlan
//
//  Created by SeokHyun on 2/28/24.
//

import Combine

enum DefaultLoginRepositoryError: Error {
  case keychainSavingFailed
  case taskAlreadyCancelled
  case invalidPlatform
}

final class DefaultLoginRepository: LoginRepository {
  // MARK: - Properties
  private var subscriptions = Set<AnyCancellable>()
  let authService: AuthenticationService
  let loginKeychainStorage: LoginResponseKeychainStorage
  let loginResultStorage: LoginResultStorage

  // MARK: - LifeCycle
  init(authService: AuthenticationService, loginResultStorage) {
    self.authService = authService
    self.loginKeychainStorage = loginKeychainStorage
  }
  
  deinit {
    print("deinit: \(Self.self)")
  }
}

// MARK: - LoginRepository
extension DefaultLoginRepository {
  func performLogin(type: OAuthType) -> AnyPublisher<Bool, Error> {
    switch type {
    case .apple:
      authService.setLoginStrategy(AppleLoginStrategy())
      return authService.performLogin()
        .tryMap { [weak self] jwtDTO in
          guard let self = self else {
            throw DefaultLoginRepositoryError.taskAlreadyCancelled
          }
          guard self.loginKeychainStorage.saveTokens(jwtDTO: jwtDTO) else {
            throw DefaultLoginRepositoryError.keychainSavingFailed
          }
          return true
        }
        .eraseToAnyPublisher()
    }
  }
}
