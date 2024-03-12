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
  case authError(Error)
}

protocol AuthenticationService {
  var loginStrategy: LoginStrategy? { get }
  var session: Sessionable { get }
  func setLoginStrategy(_ strategy: LoginStrategy)
  func performLogin() -> AnyPublisher<JWTResponseDTO, MainError>
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
  
  // keychain의 저장 성공여부를 반환
  func performLogin() -> AnyPublisher<JWTResponseDTO, MainError> {
    guard let loginStrategy = loginStrategy else {
      return Fail(error: .authService(.noStrategy))
        .eraseToAnyPublisher()
    }
    loginStrategy.login()
    // resultPublisher의 value를 받아 keychain에게 넘기고 로직 수행
    return loginStrategy.resultPublisher.eraseToAnyPublisher()
  }
}
