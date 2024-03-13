//
//  LoginViewModel.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/25.
//

import Combine
import Foundation

final class LoginViewModel {
  // MARK: - Nested
  struct Input {
    let didTapLoginButton: PassthroughSubject<OAuthType, Never>
    init(didTapLoginButton: PassthroughSubject<OAuthType, Never> = .init()) {
      self.didTapLoginButton = didTapLoginButton
    }
  }
  
  enum State {
    case none
    case presentFeed
  }
  
  // MARK: - Properties
  private let loginUseCase: LoginUseCase
  
  // MARK: - LifeCycle
  init(loginUseCase: LoginUseCase) {
    self.loginUseCase = loginUseCase
  }
  
  deinit {
    print("deinit: \(Self.self)")
  }
}

// MARK: - ViewModelCase
extension LoginViewModel: ViewModelCase {
  typealias ErrorType = Never
  
  func transform(_ input: Input) -> Output {
    return Publishers
      .MergeMany([
        didTapLoginButtonStream(input)
      ])
      .eraseToAnyPublisher()
  }
}

// MARK: - Input operator chain Flow
private extension LoginViewModel {
  private func didTapLoginButtonStream(_ input: Input) -> Output {
    return input
      .didTapLoginButton
      .flatMap { [weak self] oauthType in
        guard let self = self else { return Just(State.none).eraseToAnyPublisher() }
        
        return self.loginUseCase.execute(type: oauthType)
          .receive(on: RunLoop.main)
          .map { isSavedTokenInKeychain in
            if isSavedTokenInKeychain {
              return .presentFeed
            } else {
              return .none
            }
          }
          .catch({ error in
            Just(State.none)
          })
          .eraseToAnyPublisher()
      }
      .eraseToAnyPublisher()
  }
}
