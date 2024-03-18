//
//  DefaultLoginRepository.swift
//  travelPlan
//
//  Created by SeokHyun on 2/28/24.
//

import Combine
import Foundation

enum DefaultLoginRepositoryError: Error {
  case tokensSavingFailed
  case taskAlreadyCancelled
  case invalidPlatform
  case loginResultSavingFailed
}

final class DefaultLoginRepository {
  // MARK: - Properties
  private var subscriptions = Set<AnyCancellable>()
  private let loginResponseStorage = KeychainLoginResponseStorage()
  private let loginResultStorage: LoginResultStorage
  private let authService: AuthenticationService

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
extension DefaultLoginRepository: LoginRepository {
  func performLogin(type: OAuthType) -> AnyPublisher<Bool, Error> {
    switch type {
    case .apple:
      authService.setLoginStrategy(AppleLoginStrategy())
      
      // TODO: - 여기에서 case 추가하고 service에 구체 Strategy객체 주입
    }
    
    return authService.performLogin()
      .receive(on: DispatchQueue.global(qos: .userInitiated))
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
