//
//  DefaultLoginRepository.swift
//  travelPlan
//
//  Created by SeokHyun on 2/28/24.
//

import Combine

final class DefaultLoginRepository {
  // MARK: - Properties
  private var subscriptions = Set<AnyCancellable>()
  private let authService: AuthenticationService
//  private let 
  // MARK: - LifeCycle
  init(authService: AuthenticationService) {
    self.authService = authService
  }
  
  deinit {
    print("deinit: \(Self.self)")
  }
}

// MARK: - LoginRepository
extension DefaultLoginRepository: LoginRepository {
  func performLogin(type: OAuthType) -> AnyPublisher<Bool, MainError> {
    switch type {
    case .apple:
      authService.setLoginStrategy(AppleLoginStrategy())
      authService.performLogin()
        .map { [weak self] jwtDTO in
          // TODO: - Bool 타입을 반환해야합니다.
          KeychainManager.shared.add(
            key: KeychainKey.accessToken.rawValue,
            value: jwtDTO.accessToken.data(using: .utf8)
          )
          KeychainManager.shared.add(
            key: KeychainKey.refreshToken.rawValue,
            value: jwtDTO.refreshToken.data(using: .utf8)
          )
        }
        .eraseToAnyPublisher()
//        .sink { completion in
//          if case let .failure(error) = completion {
//            print("auth error: \(error)")
//          }
//        } receiveValue: { [weak self] jwtDTO in
//          // TODO: - keychainService에 jwtDTO를 넣어서 로직을 실행하고 성공여부를 반환해야합니다.
//          KeychainManager.shared.add(
//            key: KeychainKey.accessToken.rawValue,
//            value: jwtDTO.accessToken.data(using: .utf8)
//          )
//          KeychainManager.shared.add(
//            key: KeychainKey.refreshToken.rawValue,
//            value: jwtDTO.refreshToken.data(using: .utf8)
//          )
//        }.store(in: &subscriptions)
    }
  }
  
  // 1. ios->back, back->ios
  // 2. ios->naver, naver->ios
  // 3. ios->back, back->ios
  func performNaverLogin() {
    authService.setLoginStrategy(NaverLoginStrategy())
    authService
      .performLogin()
      .sink { completion in
        if case let .failure(error) = completion {
          print("auth error: \(error)")
        }
      } receiveValue: { responseValue in
        
      }
      .store(in: &subscriptions)
  }
  
  func fetchAuthToken(authCode: String, identityToken: String) -> AnyPublisher<Bool, MainError> {
    return Future<Bool, MainError> { promise in
      let requestDTO = LoginRequestDTO(authCode: authCode, identityToken: identityToken)
      let endpoint = LoginAPIEndPoints.getAppleAuthToken(requestDTO: requestDTO)
      self.session
        .request(endpoint: endpoint)
        .map { $0.result }
        .sink { completion in
          if case let .failure(error) = completion {
            print("DEBUG: \(error.localizedDescription)")
            promise(.failure(.networkError(error)))
          }
        } receiveValue: { responseDTO in
          
          )
          promise(.success(true))
        }
        .store(in: &self.subscriptions)
    }.eraseToAnyPublisher()
  }
}
