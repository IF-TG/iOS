//
//  DefaultLoginRepository.swift
//  travelPlan
//
//  Created by SeokHyun on 2/28/24.
//

import Combine
import Foundation
import FirebaseAuth
import SHFirestoreService

enum DefaultLoginRepositoryError: Error {
  case tokensSavingFailed
  case taskAlreadyCancelled
  case invalidPlatform
  case loginResultSavingFailed
  case invalidFirebaseAuthCurrentUserUID
}

final class DefaultLoginRepository {
  // MARK: - Properties
  private var subscriptions = Set<AnyCancellable?>()
  private let loginResponseStorage = KeychainLoginResponseStorage()
  private let loginResultStorage: LoginResultStorage
  private let authService: AuthenticationService
  private let loggedInUserRepository: LoggedInUserRepository
  private let userProfileRepository: UserProfileRepository
  private let firestoreService: FirestoreServiceProtocol
  private let firestoreStorageService = FirebaseStorageService()

  // MARK: - LifeCycle
  init(
    authService: AuthenticationService,
    loginResultStorage: LoginResultStorage,
    loggedInUserRepository: LoggedInUserRepository,
    userProfileRepository: UserProfileRepository,
    firestoreService: FirestoreServiceProtocol
  ) {
    self.authService = authService
    self.loginResultStorage = loginResultStorage
    self.loggedInUserRepository = loggedInUserRepository
    self.userProfileRepository = userProfileRepository
    self.firestoreService = firestoreService
  }
  
  deinit {
    print("deinit: \(Self.self)")
  }
}

// MARK: - LoginRepository
extension DefaultLoginRepository: LoginRepository {
  func performLogin(type: OAuthType) -> AnyPublisher<Bool, Error> {
    switch type {
    case .apple:
      authService.setLoginStrategy(AppleLoginStrategy())
    case .google:
      authService.setLoginStrategy(GoogleLoginStrategyWithFirebase())
    }
    // MARK: 여기에서 case 추가하고 service에 구체 Strategy객체 주입
    return Future<Bool, Error> { [weak self] promise in
      let authServiceSubscription = self?.authService.performLogin()
        .receive(on: DispatchQueue.global(qos: .userInitiated))
        .sink { completion in
          if case .failure(let error) = completion {
            promise(.failure(error))
          }
        } receiveValue: { jwtDTO in
          if let jwtDTO {
            self?.handleJwtDTO(jwtDTO, promise: promise)
          } else {
            self?.handleFirebaseAuthFlow(promise: promise)
          }
        }
      self?.subscriptions.insert(authServiceSubscription)
    }.eraseToAnyPublisher()
  }
}

// MARK: - Private performLogin(type:) handler
private extension DefaultLoginRepository {
  /// Backend server와 통신 후 jwtDTO를 받을 경우 이 함수에서 제어합니다.
  private func handleJwtDTO(_ jwtDTO: JWTResponseDTO, promise: Future<Bool, Error>.Promise) {
    guard loginResponseStorage.saveTokens(jwtDTO: jwtDTO) else {
      promise(.failure(DefaultLoginRepositoryError.tokensSavingFailed))
      return
    }
    // MARK: DefaultLoggedInUserRepository를 통해 로그인한 사용자의 정보를 save합니다.
    /// loggedInUserRepository.setUser(with: <#T##UserEntity#>)
    
    promise(.success(true))
  }
  
  private func handleFirebaseAuthFlow(promise: @escaping Future<Bool, Error>.Promise) {
    /// 파이어 베이스 auth를 통해 로그인한 사용자입니다.
    /// Auth.auth().currentUser?.uid정보를 fetchProfile(with:) 인자값으로 주어야 합니다.
    if Auth.auth().currentUser?.uid == nil {
      promise(.failure(DefaultLoginRepositoryError.invalidFirebaseAuthCurrentUserUID))
      return
    }
    /// 지금 현재 firestore가 아닌 spring server를 활용하기로 했기에, -1을 넣습니다. 만일 다시 firestore를 사용할 경우
    /// fetchProfile(with: userUid)  이렇게 firestore에서 제공하는 String의 uid를 넣어야합니다.
    let subscription = userProfileRepository
      .fetchProfile(with: -1)
      .sink { completion in
        if case .failure(let error) = completion {
          promise(.failure(error))
        }
      } receiveValue: { [weak self] ownerEntity in
        self?.loggedInUserRepository.setUser(with: ownerEntity)
        promise(.success(true))
      }
    subscriptions.insert(subscription)
  }
}
