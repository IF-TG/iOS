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
  private let firestoreService: FirestoreServiceProtocol
  private let firestoreStorageService = FiresabseStorageService()

  // MARK: - LifeCycle
  init(
    authService: AuthenticationService,
    loginResultStorage: LoginResultStorage,
    loggedInUserRepository: LoggedInUserRepository,
    firestoreService: FirestoreServiceProtocol
  ) {
    self.authService = authService
    self.loginResultStorage = loginResultStorage
    self.loggedInUserRepository = loggedInUserRepository
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
    // TODO: - 여기에서 case 추가하고 service에 구체 Strategy객체 주입
    return Future<Bool, Error> { [weak self] promise in
      let authServiceSubscription = self?.authService.performLogin()
        .receive(on: DispatchQueue.global(qos: .userInitiated))
        .sink { completion in
          if case .failure(let error) = completion {
            promise(.failure(error))
          }
        } receiveValue: { jwtDTO in
          if let jwtDTO {
            guard self?.loginResponseStorage.saveTokens(jwtDTO: jwtDTO) == true else {
              promise(.failure(DefaultLoginRepositoryError.tokensSavingFailed))
              return
            }
            // TODO: - DefaultLoggedInUserRepository를 통해 save합니다.
            /// loggedInUserRepository.setUser(with: <#T##UserEntity#>)
            
            promise(.success(true))
          } else {
            /// 파이어 베이스 auth를 통해 로그인한 사용자입니다.
            guard let userUid = Auth.auth().currentUser?.uid else {
              promise(.failure(DefaultLoginRepositoryError.invalidFirebaseAuthCurrentUserUID))
              return
            }
            
            let endpoint = FirestoreMyProfileAPIEndopint.fetchUserProfileEndpoint(userUID: userUid)
            let firestoreServiceSubscription = self?.firestoreService.request(endpoint: endpoint)
              .sink { completion in
                if case .failure(let error) = completion {
                  promise(.failure(error))
                }
              } receiveValue: { responseDTO in
                if responseDTO.profileImagePath == "" {
                  self?.loggedInUserRepository.setUser(with: responseDTO.toDomain(with: nil))
                  promise(.success(true))
                } else {
                  let firestoreStorageSubscription = self?.firestoreStorageService
                    .fetchImage(responseDTO.profileImagePath, type: .profileImage)
                    .sink { completion in
                      if case .failure(let error) = completion {
                        promise(.failure(error))
                      }
                    } receiveValue: { data in
                      self?.loggedInUserRepository.setUser(with: responseDTO.toDomain(with: data))
                      promise(.success(true))
                    }
                  self?.subscriptions.insert(firestoreStorageSubscription)
                  
                }
              }
            self?.subscriptions.insert(firestoreServiceSubscription)
          }
        }
      self?.subscriptions.insert(authServiceSubscription)
    }.eraseToAnyPublisher()
  }
}
