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
  ) -> AnyPublisher<AuthToken, Error>
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
  func execute(requestValue: LoginRequestValue) -> AnyPublisher<AuthToken, Error> {
    switch requestValue.loginType {
    case .apple:
      return loginRepository.fetchAuthToken(authCode: requestValue.authorizationCode,
                                            identityToken: requestValue.identityToken)
    }
  }
}

struct LoginRequestValue {
  enum LoginType: String {
    case apple
    //    case kakao
    //    case naver
    //    case google
  }
  
  let loginType: LoginType
  let authorizationCode: String
  let identityToken: String
}

struct AuthToken {
  let accessToken: String
  let refreshToken: String
}
