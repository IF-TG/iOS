//
//  DefaultLoginRepository.swift
//  travelPlan
//
//  Created by SeokHyun on 2/28/24.
//

import Combine

enum DefaultLoginRepositoryError: Error {
  case tokensSavingFailed
  case taskAlreadyCancelled
  case invalidPlatform
  case loginResultSavingFailed
}

final class DefaultLoginRepository: LoginRepository {
  // MARK: - Properties
  private var subscriptions = Set<AnyCancellable>()
  private let loginResponseStorage = KeychainLoginResponseStorage()
  let authService: AuthenticationService
  let loginResultStorage: LoginResultStorage

  // MARK: - LifeCycle
  init(authService: AuthenticationService, loginResultStorage: LoginResultStorage) {
    self.authService = authService
    self.loginResultStorage = loginResultStorage
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
          guard self.loginResponseStorage.saveTokens(jwtDTO: jwtDTO) else {
            throw DefaultLoginRepositoryError.tokensSavingFailed
          }
          // TODO: - loginResultStorage를 통해 save합니다.
//          if loginResultStorage.save() {
//            return true
//          } else {
//            throw DefaultLoginRepositoryError.loginResultSavingFailed
//          }
          return true
        }
        .eraseToAnyPublisher()
    }
  }
}
