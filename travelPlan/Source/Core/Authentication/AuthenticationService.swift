//
//  AuthenticationService.swift
//  travelPlan
//
//  Created by SeokHyun on 3/2/24.
//

import Foundation
import Combine
import Alamofire

enum AuthenticationServiceError: Error {
  case noStrategy
}

protocol AuthenticationService {
  var sessionProvider: Sessionable { get }
  func setLoginStrategy(_ strategy: LoginStrategy)
  func performLogin() -> AnyPublisher<JWTResponseDTO, Error>
}

final class DefaultAuthenticationService: AuthenticationService {
  // MARK: - Properties
  var loginStrategy: LoginStrategy?
  let sessionProvider: Sessionable
  
  // MARK: - LifeCycle
  init(sessionProvider: Sessionable) {
    self.sessionProvider = sessionProvider
  }
  
  func setLoginStrategy(_ strategy: LoginStrategy) {
    self.loginStrategy = strategy
    self.loginStrategy?.sessionable = sessionProvider
  }
  
  func performLogin() -> AnyPublisher<JWTResponseDTO, Error> {
    guard let loginStrategy = loginStrategy else {
      return Fail(error: AuthenticationServiceError.noStrategy)
        .eraseToAnyPublisher()
    }
    loginStrategy.login()
    return loginStrategy.resultPublisher.eraseToAnyPublisher()
  }
}
