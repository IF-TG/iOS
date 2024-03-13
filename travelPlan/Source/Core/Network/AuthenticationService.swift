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
  func setLoginStrategy(_ strategy: LoginStrategy)
  func performLogin() -> AnyPublisher<JWTResponseDTO, Error>
}

final class DefaultAuthenticationService: AuthenticationService {
  // MARK: - Properties
  var loginStrategy: LoginStrategy?
  private let sessionProvider: Sessionable
  
  // MARK: - LifeCycle
  init(sessionProvider: Sessionable) {
    self.sessionProvider = sessionProvider
  }
  
  func setLoginStrategy(_ strategy: LoginStrategy) {
    self.loginStrategy = strategy
  }
  
  // keychain의 저장 성공여부를 반환
  func performLogin() -> AnyPublisher<JWTResponseDTO, Error> {
    guard let loginStrategy = loginStrategy else {
      return Fail(error: AuthenticationServiceError.noStrategy)
        .eraseToAnyPublisher()
    }
    loginStrategy.login()
    // resultPublisher의 value를 받아 keychain에게 넘기고 로직 수행
    return loginStrategy.resultPublisher.eraseToAnyPublisher()
  }
}
