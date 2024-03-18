//
//  LoginUseCase.swift
//  travelPlan
//
//  Created by SeokHyun on 2/28/24.
//

import Combine

protocol LoginUseCase {
  func execute(
    type: OAuthType
  ) -> AnyPublisher<Bool, Error>
}

final class DefaultLoginUseCase {
  // MARK: - Properties
  private let loginRepository: LoginRepository
  
  // MARK: - LifeCycle
  init(loginRepository: LoginRepository) {
    self.loginRepository = loginRepository
  }
  
  deinit {
    print("deinit: \(Self.self)")
  }
}

// MARK: - LoginUseCase
extension DefaultLoginUseCase: LoginUseCase {
  func execute(type: OAuthType) -> AnyPublisher<Bool, Error> {
    return loginRepository
      .performLogin(type: type)
      .eraseToAnyPublisher()
  }
}
