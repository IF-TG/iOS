//
//  LoginViewModel.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/25.
//

import Combine

final class LoginViewModel {
  typealias Output = AnyPublisher<State, ErrorType>
  
  struct Input {
    let didTapLoginButton: PassthroughSubject<OAuthType, ErrorType>
    let didCompleteWithAuthorization: PassthroughSubject<AuthenticationResponseValue, Never>
    
    init(didTapLoginButton: PassthroughSubject<OAuthType, ErrorType> = .init(),
         didCompleteWithAuthorization: PassthroughSubject<AuthenticationResponseValue, Never> = .init()) {

      self.didTapLoginButton = didTapLoginButton
      self.didCompleteWithAuthorization = didCompleteWithAuthorization
    }
  }
  enum ErrorType: Error {
    case none
    case unexpectedError
  }
  enum State {
    case none
    case performAuthRequest(OAuthType)
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
  func transform(_ input: Input) -> Output {
    return Publishers
      .MergeMany([
        didTapLoginButtonStream(input),
        didCompleteWithAuthorizationStream(input)
      ])
      .eraseToAnyPublisher()
  }
}

// MARK: - Input operator chain Flow
private extension LoginViewModel {
  private func didCompleteWithAuthorizationStream(_ input: Input) -> Output {
    return input
      .didCompleteWithAuthorization
      .flatMap { [weak self] responseValue in
        guard let self = self else {
          return Just(State.none).eraseToAnyPublisher()
        }
        return self.loginUseCase
          .execute(requestValue: .init(
            loginType: .apple,
            authorizationCode: responseValue.authorizationCode,
            identityToken: responseValue.identityToken))
          .map { isLoggedIn in
            return isLoggedIn ? State.presentFeed : State.none
          }
          .eraseToAnyPublisher()
      }
      .setFailureType(to: ErrorType.self)
      .eraseToAnyPublisher()
  }
  
  private func didTapLoginButtonStream(_ input: Input) -> Output {
    return input
      .didTapLoginButton
      .tryMap { oauthType in
        return State.performAuthRequest(oauthType)
      }
      .mapError { $0 as? ErrorType ?? .unexpectedError }
      .eraseToAnyPublisher()
  }
}
