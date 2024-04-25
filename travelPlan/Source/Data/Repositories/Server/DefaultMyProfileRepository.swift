//
//  DefaultMyProfileRepository.swift
//  travelPlan
//
//  Created by 양승현 on 2/27/24.
//

import Combine
import Foundation

// MARK: - Publisher extension
private extension Publisher {
  func mapMyProfileUsecaseError<E>(
    _ transform: @escaping (Self.Failure) -> E
  ) -> Publishers.MapError<Self, Error> {
    return self.mapError { error -> MyProfileUseCaseError in
      if let connectionError = error.asAFError?.asConnectionError {
        return MyProfileUseCaseError.networkError(connectionError)
      }
      return MyProfileUseCaseError.unknown(error.localizedDescription)
    }
  }
}

final class DefaultMyProfileRepository {
  // MARK: - Dependencies
  private let service: Sessionable
  private lazy var othersProfileRepository = DefaultOthersProfileRepository(service: service)
  private let loggedInUserRepository: LoggedInUserRepository
  private let backgroundQueue: DispatchQueue
  
  // MARK: - Properties
  private var subscriptions = Set<AnyCancellable>()
  
  // MARK: - Lifecycle
  init(
    service: Sessionable,
    loggedInUserRepository: LoggedInUserRepository,
    backgroundQueue: DispatchQueue = .global(qos: .default)
  ) {
    self.service = service
    self.loggedInUserRepository = loggedInUserRepository
    self.backgroundQueue = backgroundQueue
  }
}

// MARK: - MyProfileRepository
extension DefaultMyProfileRepository: MyProfileRepository {
  var isProfileSavedInServer: Bool {
    loggedInUserRepository.isSavedProfileInServer
  }
  
  func checkIfUserNicknameDuplicate(with name: String) -> AnyPublisher<Bool, Error> {
    return Future { [weak self] promise in
      guard let self else {
        promise(.failure(ReferenceError.invalidReference))
        return
      }
      
      let reqeustDTO = UserNicknameRequestDTO(nickname: name)
      let endpoint = UserInfoAPIEndpoint.checkIfNicknameDuplicate(with: reqeustDTO)
      
      service.request(endpoint: endpoint)
        .subscribe(on: backgroundQueue)
        .mapMyProfileUsecaseError { $0 }
        .sink { completion in
          switch completion {
          case .finished:
            return
          case .failure(let error):
            promise(.failure(error))
          }
        } receiveValue: { responseDTO in
          promise(.success(responseDTO.result))
        }.store(in: &subscriptions)
    }.eraseToAnyPublisher()
  }
  
  func updateUserNickname(with name: String) -> AnyPublisher<Bool, Error> {
    return Future { [weak self] promise in
      guard let self else {
        promise(.failure(ReferenceError.invalidReference))
        return
      }
      
      guard let loggedInUserId = loggedInUserRepository.id, let userId = Int64(loggedInUserId) else {
        promise(.failure(MyProfileUseCaseError.invalidUserId))
        return
      }
      
      let requestDTO = UserNicknamePatchRequestDTO(nickname: name, userId: userId)
      let endpoint = UserInfoAPIEndpoint.updateUserNickname(with: requestDTO)
      service.request(endpoint: endpoint)
        .subscribe(on: backgroundQueue)
        .mapMyProfileUsecaseError { $0 }
        .sink { completion in
          switch completion {
          case .finished:
            return
          case .failure(let error):
            promise(.failure(error))
          }
        } receiveValue: { [weak self] responseDTO in
          if responseDTO.result {
            self?.loggedInUserRepository.updateNickname(with: name)
          }
          promise(.success(responseDTO.result))
        }.store(in: &subscriptions)
    }.eraseToAnyPublisher()
  }
  
  /// 업데이트는 서버 로직에서 삭제 -> 저장을 한번에 하는 기능입니다.
  func updateProfileImage(with profile: String) -> AnyPublisher<Bool, Error> {
    return Future<Bool, Error> { [weak self] promise in
      guard let self else {
        promise(.failure(ReferenceError.invalidReference))
        return
      }
      
      guard let loggedInUserId = loggedInUserRepository.id, let userId = Int64(loggedInUserId) else {
        promise(.failure(MyProfileUseCaseError.invalidUserId))
        return
      }
      
      let userIdReqeustDTO = UserIdReqeustDTO(userId: userId)
      let reqeustDTO = UserProfileRequestDTO(profile: profile)
      let endpoint = UserInfoAPIEndpoint.updateProfile(withQuery: userIdReqeustDTO, body: reqeustDTO)
      service.request(endpoint: endpoint)
        .subscribe(on: backgroundQueue)
        .mapMyProfileUsecaseError { $0 }
        .sink { completion in
          if case .failure(let error) = completion {
            promise(.failure(error))
          }
        } receiveValue: { [weak self] responseDTO in
          let isSucceed = (200...299).contains(Int(responseDTO.statusCode) ?? -1)
          self?.loggedInUserRepository.updateProfileURL(with: responseDTO.result.imageURL)
          promise(.success(isSucceed))
        }.store(in: &subscriptions)
    }.eraseToAnyPublisher()
  }
  
  func saveProfileImage(with profile: String) -> AnyPublisher<Bool, Error> {
    return Future<Bool, Error> { [weak self] promise in
      guard let self else {
        promise(.failure(ReferenceError.invalidReference))
        return
      }
      
      guard
        let loggedInUserId = loggedInUserRepository.id,
        let userId = Int64(loggedInUserId)
      else {
        promise(.failure(MyProfileUseCaseError.invalidUserId))
        return
      }
      
      let userIdRequestDTO = UserIdReqeustDTO(userId: userId)
      let requestDTO = UserProfileRequestDTO(profile: profile)
      let endpoint = UserInfoAPIEndpoint.saveProfile(withQuery: userIdRequestDTO, body: requestDTO)
      service.request(endpoint: endpoint)
        .subscribe(on: backgroundQueue)
        .mapMyProfileUsecaseError { $0 }
        .sink { completion in
          if case .failure(let error) = completion {
            promise(.failure(error))
          }
        } receiveValue: { [weak self] responseDTO in
          self?.loggedInUserRepository.updateProfileURL(with: profile)
          let isSucceed = (200...299).contains(Int(responseDTO.statusCode) ?? -1)
          promise(.success(isSucceed))
        }.store(in: &subscriptions)
    }.eraseToAnyPublisher()
  }
  
  func deleteProfileImage() -> AnyPublisher<Bool, Error> {
    return Future<Bool, Error> { [weak self] promise in
      guard let self else {
        promise(.failure(ReferenceError.invalidReference))
        return
      }
      
      guard let loggedInUserId = loggedInUserRepository.id, let userId = Int64(loggedInUserId) else {
        promise(.failure(MyProfileUseCaseError.invalidUserId))
        return
      }
      
      let requestDTO = UserIdReqeustDTO(userId: userId)
      let endpoint = UserInfoAPIEndpoint.deleteProfile(with: requestDTO)
      
      service.request(endpoint: endpoint)
        .subscribe(on: backgroundQueue)
        .mapMyProfileUsecaseError { $0 }
        .sink { completion in
          if case .failure(let error) = completion {
            promise(.failure(error))
          }
        } receiveValue: { [weak self] responseDTO in
          self?.loggedInUserRepository.deleteProfile()
          promise(.success(responseDTO.result))
        }.store(in: &subscriptions)
    }.eraseToAnyPublisher()
  }
  
  func fetchProfileImage() -> AnyPublisher<ProfileImageEntity, Error> {
    return Future { [weak self] promise in
      guard let self else {
        promise(.failure(ReferenceError.invalidReference))
        return
      }
      
      // UserDefaults 확인
      if let imageURL = loggedInUserRepository.profileURL {
        promise(.success(.init(image: imageURL)))
      }
      
      guard let loggedInUserId = loggedInUserRepository.id else {
        promise(.failure(MyProfileUseCaseError.invalidUserId))
        return
      }

      // 프로필 없는 경우 서버에서 불러오기
      othersProfileRepository.fetchProfile(with: loggedInUserId)
        .subscribe(on: backgroundQueue)
        .mapMyProfileUsecaseError { $0 }
        .sink { completion in
          if case .failure(let error) = completion {
            promise(.failure(error))
          }
        } receiveValue: { [weak self] profileImageEntity in
          self?.loggedInUserRepository.updateProfileURL(with: profileImageEntity.image)
          promise(.success(profileImageEntity))
        }.store(in: &subscriptions)
    }.eraseToAnyPublisher()
  }
  
  func fetchProfile(with userId: String) -> AnyPublisher<UserEntity, any Error> {
    fatalError(" 서버에서 미 구현된 api 입니다.")
  }
  
  func saveProfile(with userId: String, nickname: String, profileImage: String) -> AnyPublisher<Void, any Error> {
    fatalError("서버에서 미 구현된 api 입니다.")
  }
}
