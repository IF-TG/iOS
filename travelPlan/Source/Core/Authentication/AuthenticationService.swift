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
  func performLogin() -> AnyPublisher<JWTResponseDTO?, Error>
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
  
  // MARK: login() 함수가 끝난후에 resultPublisher를 반환하면 바인딩해도 resultPublisehr가 동작될지 않을 가능성이 있습니다.
  func performLogin() -> AnyPublisher<JWTResponseDTO?, Error> {
    guard let loginStrategy = loginStrategy else {
      return Fail(error: AuthenticationServiceError.noStrategy)
        .eraseToAnyPublisher()
    }
    loginStrategy.login()
    return loginStrategy.resultPublisher.eraseToAnyPublisher()
  }
}
