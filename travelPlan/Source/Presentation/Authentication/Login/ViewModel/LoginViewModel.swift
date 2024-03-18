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
        
<<<<<<< HEAD
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
=======
        return self.loginUseCase.execute(type: oauthType)
          .receive(on: RunLoop.main)
          .map { isSavedTokenInKeychain in
            if isSavedTokenInKeychain {
              return .presentFeed
            } else {
              return .none
            }
>>>>>>> 02c74f799dc34ed1ff76ee1c0b7fef6351713e9e
          }
          .catch { error in
            print("error: \(error.localizedDescription)")
            return Just(State.none).eraseToAnyPublisher()
          }
          .eraseToAnyPublisher()
      }
      .eraseToAnyPublisher()
  }
}
