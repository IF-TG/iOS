//
//  AuthenticationService.swift
//  travelPlan
//
//  Created by SeokHyun on 3/2/24.
//

import Foundation
import Combine
import Alamofire

struct AuthenticationResponseValue {
  let authorizationCode: String
  let identityToken: String
}

enum AuthenticationServiceError: Error {
  case noStrategy
  case authError(Error)
}

protocol AuthenticationService {
  var loginStrategy: LoginStrategy? { get }
  var session: Sessionable { get }
  func setLoginStrategy(_ strategy: LoginStrategy)
  func performLogin() -> AnyPublisher<AuthenticationResponseValue, AuthenticationServiceError>
}

final class DefaultAuthenticationService: AuthenticationService {
  // MARK: - Properties
  var loginStrategy: LoginStrategy?
  let session: Sessionable
  
  // MARK: - LifeCycle
  init(session: Sessionable) {
    self.session = session
  }
  
  func setLoginStrategy(_ strategy: LoginStrategy) {
    self.loginStrategy = strategy
    self.loginStrategy?.session = session
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
