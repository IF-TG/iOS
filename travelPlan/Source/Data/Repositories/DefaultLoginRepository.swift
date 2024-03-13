//
//  DefaultLoginRepository.swift
//  travelPlan
//
//  Created by SeokHyun on 2/28/24.
//

import Combine

final class DefaultLoginRepository: LoginRepository {
  // MARK: - Properties
  private var subscriptions = Set<AnyCancellable>()
  let authService: AuthenticationService
  let loginResponseStorage: LoginResponseStorage

  // MARK: - LifeCycle
  init(authService: AuthenticationService, loginResponseStorage: LoginResponseStorage) {
    self.authService = authService
    self.loginResponseStorage = loginResponseStorage
  }
  
  deinit {
    print("deinit: \(Self.self)")
  }
}

// MARK: - LoginRepository
extension DefaultLoginRepository {
  func performLogin(type: OAuthType) -> AnyPublisher<Bool, MainError> {
    switch type {
    case .apple:
      authService.setLoginStrategy(AppleLoginStrategy())
      authService.performLogin()
        .map { [weak self] jwtDTO in
          // TODO: - keychainStorage에서 Bool 타입을 반환해야합니다.
          KeychainManager.shared.add(
            key: KeychainKey.accessToken.rawValue,
            value: jwtDTO.accessToken.data(using: .utf8)
          )
          KeychainManager.shared.add(
            key: KeychainKey.refreshToken.rawValue,
            value: jwtDTO.refreshToken.data(using: .utf8)
          )
        }
        .eraseToAnyPublisher()
    }
  }
  
  // 1. ios->back, back->ios
  // 2. ios->naver, naver->ios
  // 3. ios->back, back->ios
//  func performNaverLogin() {
//    authService.setLoginStrategy(NaverLoginStrategy())
//    authService
//      .performLogin()
//      .sink { completion in
//        if case let .failure(error) = completion {
//          print("auth error: \(error)")
//        }
//      } receiveValue: { responseValue in
//        
//      }
//      .store(in: &subscriptions)
//  }
}
