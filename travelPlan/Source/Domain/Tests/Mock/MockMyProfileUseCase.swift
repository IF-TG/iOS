//
//  MockMyProfileUseCase.swift
//  travelPlan
//
//  Created by 양승현 on 3/11/24.
//

import Foundation
import Combine

struct MockUserProfileRepository: UserProfileRepository {
  func fetchProfileImageData(with userId: String) -> AnyPublisher<ProfileImageData, any Error> {
    return Just("사용자프로필".data(using: .utf8)!)
      .setFailureType(to: ReferenceError.self)
      .mapError { $0 as Error }
      .eraseToAnyPublisher()
  }
  
  func fetchProfile(with userId: String) -> AnyPublisher<UserEntity, any Error> {
    return Just(UserEntity(id: "1", nickname: "짱구", isSavedProfileInServer: false))
      .setFailureType(to: ReferenceError.self)
      .mapError { $0 as Error }
      .eraseToAnyPublisher()
  }
}

final class MockMyProfileUseCase: MyProfileUseCase {
  init() {
    // Mock session주입
    let mockSession = MockSession.default
    let sessionProvider = SessionProvider(session: mockSession)
    let mockUserStorage = MockUserStorage()
    
    let myProfileRepository = DefaultMyProfileRepository(
      service: sessionProvider,
      userStorage: mockUserStorage)
    defaultMyProfileUseCase = DefaultMyProfileUseCase(
      myProfileRepository: myProfileRepository,
      userProfileRepository: MockUserProfileRepository(),
      loggedInUserRepository: DefaultLoggedInUserRepository(storage: mockUserStorage))
  }
  
  private var defaultMyProfileUseCase: MyProfileUseCase
  
  private var subscriptions = Set<AnyCancellable>()
  
  var isProfileSavedInServer: Bool {
    defaultMyProfileUseCase.isProfileSavedInServer
  }
  
  func checkIfNicknameDuplicate(with name: String) -> AnyPublisher<Bool, any Error> {
    return Future<Bool, Error> { promise in
      if name == "무야호" {
        promise(.success(true))
      }
      promise(.success(false))
    }
    .delay(for: .seconds(0.2), scheduler: DispatchQueue.global(qos: .background))
    .eraseToAnyPublisher()
  }

  func updateNickname(with name: String) -> AnyPublisher<Bool, any Error> {
    return Future<Bool, Error> { promise in
      promise(.success(true))
    }.delay(for: .seconds(0.2), scheduler: DispatchQueue.global(qos: .background))
      .eraseToAnyPublisher()
  }
  
  func updateProfile(with base64String: String) -> AnyPublisher<Bool, any Error> {
    let json = """
          {
            "result": {
              "imageUrl": "\(base64String)",
              "userId": 1
            },
            "status": "OK",
            "statusCode": "200",
            "message": "success"
          }
          """
    MockUrlProtocol.requestHandler = { _ in
      let responseData = json.data(using: .utf8)!
      return ((HTTPURLResponse(), responseData))
    }
    return Future<Bool, Error> { promise in
      DispatchQueue.global(qos: .background).async {
        self.defaultMyProfileUseCase.updateProfile(with: base64String)
          .delay(for: .seconds(0.1), scheduler: DispatchQueue.global(qos: .background))
          .sink { completion in
            if case .failure(let error) = completion {
              promise(.failure(error))
            }
          } receiveValue: { result in
            promise(.success(result))
          }.store(in: &self.subscriptions)
        
      }
    }.eraseToAnyPublisher()
  }
  
  func saveProfile(with base64String: String) -> AnyPublisher<Bool, any Error> {
    let json = """
          {
            "result": {
              "imageUrl": "\(base64String)",
              "userId": 1
            },
            "status": "OK",
            "statusCode": "200",
            "message": "success"
          }
          """
    MockUrlProtocol.requestHandler = { _ in
      let responseData = json.data(using: .utf8)!
      return ((HTTPURLResponse(), responseData))
    }
    return Future<Bool, Error> { promise in
      DispatchQueue.global(qos: .background).async {
        self.defaultMyProfileUseCase.saveProfile(with: base64String)
          .delay(for: .seconds(0.1), scheduler: DispatchQueue.global(qos: .background))
          .sink { completion in
            if case .failure(let error) = completion {
              promise(.failure(error))
            }
          } receiveValue: { result in
            promise(.success(result))
          }.store(in: &self.subscriptions)
      }
    }.eraseToAnyPublisher()
  }
  
  func deleteProfile() -> AnyPublisher<Bool, any Error> {
    let json = """
          {
            "result": true,
            "status": "OK",
            "statusCode": "200",
            "message": "success"
          }
          """
    MockUrlProtocol.requestHandler = { _ in
      let responseData = json.data(using: .utf8)!
      return ((HTTPURLResponse(), responseData))
    }
    return Future<Bool, Error> { promise in
      DispatchQueue.global(qos: .background).async {
        self.defaultMyProfileUseCase.deleteProfile()
          .delay(for: .seconds(0.1), scheduler: DispatchQueue.global(qos: .background))
          .sink { completion in
            if case .failure(let error) = completion {
              promise(.failure(error))
            }
          } receiveValue: { result in
            promise(.success(result))
          }.store(in: &self.subscriptions)
        
      }
    }.eraseToAnyPublisher()
  }
  
  func fetchProfile() -> AnyPublisher<ProfileImageEntity, any Error> {
    let json = """
          {
            "result": {
              "imageUrl": "성장해 나가 보자구!!!",
              "userId": 1
            },
            "status": "OK",
            "statusCode": "200",
            "message": "success"
          }
          """
    MockUrlProtocol.requestHandler = { _ in
      let responseData = json.data(using: .utf8)!
      return ((HTTPURLResponse(), responseData))
    }
    return Future<ProfileImageEntity, Error> { promise in
      DispatchQueue.global(qos: .background).async {
        self.defaultMyProfileUseCase.fetchProfile()
          .delay(for: .seconds(0.1), scheduler: DispatchQueue.global(qos: .background))
          .sink { completion in
            if case .failure(let error) = completion {
              promise(.failure(error))
            }
          } receiveValue: { result in
            promise(.success(result))
          }.store(in: &self.subscriptions)
        
      }
    }.eraseToAnyPublisher()
  }
}
