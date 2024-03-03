//
//  LoginUseCase.swift
//  travelPlan
//
//  Created by SeokHyun on 2/28/24.
//

import Combine

protocol LoginUseCase {
  func execute(
    requestValue: LoginRequestValue
  ) -> AnyPublisher<Bool, Never>
}

final class DefaultLoginUseCase {
  // MARK: - Properties
  private let loginRepository: LoginRepository
  
  // MARK: - LifeCycle
  init(loginRepository: LoginRepository) {
    self.loginRepository = loginRepository
  }
}

// MARK: - LoginUseCase
extension DefaultLoginUseCase: LoginUseCase {
  func execute(requestValue: LoginRequestValue) -> AnyPublisher<Bool, Never> {
    switch requestValue.loginType {
    case .apple:
      return loginRepository.fetchAuthToken(
        authCode: requestValue.authorizationCode,
        identityToken: requestValue.identityToken
      ).eraseToAnyPublisher()
    }
  }
}

struct LoginRequestValue {
  let loginType: OAuthType
  let authorizationCode: String
  let identityToken: String
}

struct AuthToken {
  let accessToken: String
  let refreshToken: String
}
