//
//  LoginViewModel.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/25.
//

import Combine

final class LoginViewModel {
  struct Input {
    let didTapLoginButton: PassthroughSubject<OAuthType, Never>
    let didCompleteWithAuthorization: PassthroughSubject<AuthenticationResponseValue, Never>
    
    init(didTapLoginButton: PassthroughSubject<OAuthType, Never> = .init(),
         didCompleteWithAuthorization: PassthroughSubject<AuthenticationResponseValue, Never> = .init()) {

      self.didTapLoginButton = didTapLoginButton
      self.didCompleteWithAuthorization = didCompleteWithAuthorization
    }
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
  typealias ErrorType = Never
  
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
          return Just(State.none)
            .eraseToAnyPublisher()
        }
        
        return self.loginUseCase
          .execute(requestValue: .init(
            loginType: .apple,
            authorizationCode: responseValue.authorizationCode,
            identityToken: responseValue.identityToken))
          .map { isLoggedIn in
            // MARK: - 로그인이 완료될 경우 사용자의 정보(아이디, 이름, 프로필이 서버에 저장됬는지 여부, 프로필 이미지)를
            // 받은 후에 UserDefaultsManager.setUser에 저장 후 메인 화면으로 넘어와야 합니다.
            // 프로필 최초 저장은 프로필 url이 있는 경우 true로 설정해야합니다.
            return isLoggedIn ? State.presentFeed : State.none
          }
          .catch { error in
            // TODO: - 추후 Error를 핸들링해야합니다.
            print(error)
            return Just(State.none)
          }
          .eraseToAnyPublisher()
      }
      .eraseToAnyPublisher()
  }
  
  private func didTapLoginButtonStream(_ input: Input) -> Output {
    return input
      .didTapLoginButton
      .map { oauthType in
        return State.performAuthRequest(oauthType)
      }
      .eraseToAnyPublisher()
  }
}