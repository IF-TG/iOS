//
//  AuthenticationService.swift
//  travelPlan
//
//  Created by SeokHyun on 3/2/24.
//

import Foundation
import Combine

struct AuthenticationResponseValue {
  let authorizationCode: String
  let identityToken: String
}

enum AuthenticationServiceError: Error {
  case noStrategy
}

final class AuthenticationService {
  // MARK: - Properties
  private var loginStrategy: LoginStrategy?
  
  // MARK: - Helpers
  func setLoginStrategy(_ strategy: LoginStrategy) {
    self.loginStrategy = strategy
  }
  
  func performLogin() -> AnyPublisher<AuthenticationResponseValue, AuthenticationServiceError> {
    guard let loginStrategy = loginStrategy else {
      return Fail<AuthenticationResponseValue, AuthenticationServiceError>(error: .noStrategy)
        .eraseToAnyPublisher()
    }
    loginStrategy.login()
    return loginStrategy.resultPublisher.eraseToAnyPublisher()
  }
}
