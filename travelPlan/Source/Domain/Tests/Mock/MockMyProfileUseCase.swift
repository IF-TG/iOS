//
//  MockMyProfileUseCase.swift
//  travelPlan
//
//  Created by 양승현 on 3/11/24.
//

import Foundation
import Combine

final class MockMyProfileUseCase: MyProfileUseCase {
  init() {
    // Mock session주입
    let mockSession = MockSession.default
    let sessionProvider = SessionProvider(session: mockSession)
    let mockUserStorage = MockUserStorage()
    let myProfileRepository = DefaultMyProfileRepository(
      service: sessionProvider,
      loggedInUserRepository: DefaultLoggedInUserRepository(storage: mockUserStorage))
    defaultMyProfileUseCase = DefaultMyProfileUseCase(myProfileRepository: myProfileRepository)
  }
  
  private var defaultMyProfileUseCase: MyProfileUseCase
  
  private var subscriptions = Set<AnyCancellable>()
  
  var isProfileSavedInServer: Bool {
    defaultMyProfileUseCase.isProfileSavedInServer
  }
  
  func checkIfNicknameDuplicate(with name: String) -> AnyPublisher<Bool, any Error> {
    var mockResult = false
    if name == "무야호" {
      /// 무야호일 경우 중복된 이름.
      mockResult = true
    }
    let json = """
          {
            "result": \(mockResult),
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
        self.defaultMyProfileUseCase.checkIfNicknameDuplicate(with: name)
          .delay(for: .seconds(0.5), scheduler: DispatchQueue.global(qos: .background))
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

  func updateNickname(with name: String) -> AnyPublisher<Bool, any Error> {
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
        self.defaultMyProfileUseCase.updateNickname(with: name)
          .delay(for: .seconds(0.5), scheduler: DispatchQueue.global(qos: .background))
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
          .delay(for: .seconds(0.5), scheduler: DispatchQueue.global(qos: .background))
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
          .delay(for: .seconds(0.5), scheduler: DispatchQueue.global(qos: .background))
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
          .delay(for: .seconds(0.5), scheduler: DispatchQueue.global(qos: .background))
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
          .delay(for: .seconds(0.5), scheduler: DispatchQueue.global(qos: .background))
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
