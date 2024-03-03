//
//  AuthenticationService.swift
//  travelPlan
//
//  Created by SeokHyun on 3/2/24.
//

import Foundation
import Combine

final class AuthenticationService {
  // MARK: - Properties
  private var loginStrategy: LoginStrategy?
  
  // MARK: - Helpers
  func setLoginStrategy(_ strategy: LoginStrategy) {
    self.loginStrategy = strategy
  }
  
  func performLogin() -> AnyPublisher<AuthToken, AuthServiceError> {
    guard let loginStrategy = loginStrategy else {
      return Fail<AuthToken, AuthServiceError>(error: .noStrategy).eraseToAnyPublisher()
    }
    loginStrategy.login()
    return loginStrategy.loginPublisher.eraseToAnyPublisher()
  }
}

enum AuthServiceError: Error {
  case noStrategy
}
