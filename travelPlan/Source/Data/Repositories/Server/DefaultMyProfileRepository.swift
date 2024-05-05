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
  private lazy var othersProfileRepository = DefaultUserProfileRepository(service: service)
  private let userStorage: OwnerStorage
  private let backgroundQueue: DispatchQueue
  
  // MARK: - Properties
  private var subscriptions = Set<AnyCancellable>()
  
  // MARK: - Lifecycle
  init(
    service: Sessionable,
    userStorage: OwnerStorage,
    backgroundQueue: DispatchQueue = .global(qos: .default)
  ) {
    self.service = service
    self.userStorage = userStorage
    self.backgroundQueue = backgroundQueue
  }
}

// MARK: - MyProfileRepository
extension DefaultMyProfileRepository: MyProfileRepository {
  var isProfileSavedInServer: Bool {
    userStorage.isSavedProfileInServer
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
      
      guard let loggedInUserId = userStorage.id, let userId = Int64(loggedInUserId) else {
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
            self?.userStorage.updateNickname(with: name)
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
      
      guard let loggedInUserId = userStorage.id, let userId = Int64(loggedInUserId) else {
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
          if let imageData = Data(base64Encoded: responseDTO.result.imageURL) {
            self?.userStorage.updateProfileImageData(with: imageData)
            promise(.success(isSucceed))
          } else {
            promise(.failure(Swift.DecodingError.dataCorrupted(DecodingError.Context(
              codingPath: [], 
              debugDescription: "Failed to convert image to data"))))
          }
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
        let loggedInUserId = userStorage.id,
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
          let isSucceed = (200...299).contains(Int(responseDTO.statusCode) ?? -1)
          if let imageData = Data(base64Encoded: responseDTO.result.imageURL) {
            self?.userStorage.updateProfileImageData(with: imageData)
            promise(.success(isSucceed))
          } else {
            promise(.failure(Swift.DecodingError.dataCorrupted(DecodingError.Context(
              codingPath: [],
              debugDescription: "Failed to convert image to data"))))
          }
        }.store(in: &subscriptions)
    }.eraseToAnyPublisher()
  }
  
  func deleteProfileImage() -> AnyPublisher<Bool, Error> {
    return Future<Bool, Error> { [weak self] promise in
      guard let self else {
        promise(.failure(ReferenceError.invalidReference))
        return
      }
      
      guard let loggedInUserId = userStorage.id, let userId = Int64(loggedInUserId) else {
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
          self?.userStorage.deleteProfileImageData()
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
      if let imageData = userStorage.profileImageData {
        promise(.success(.init(image: imageData)))
      }
      
      guard let loggedInUserId = userStorage.id else {
        promise(.failure(MyProfileUseCaseError.invalidUserId))
        return
      }

      // 프로필 없는 경우 서버에서 불러오기
      othersProfileRepository.fetchProfileImageData(with: loggedInUserId)
        .subscribe(on: backgroundQueue)
        .mapMyProfileUsecaseError { $0 }
        .sink { completion in
          if case .failure(let error) = completion {
            promise(.failure(error))
          }
        } receiveValue: { [weak self] profileImageData in
          self?.userStorage.updateProfileImageData(with: profileImageData)
          promise(.success(ProfileImageEntity(image: profileImageData)))
        }.store(in: &subscriptions)
    }.eraseToAnyPublisher()
  }
  
  func saveProfile(with userId: String, nickname: String, profileImageData: Data) -> AnyPublisher<Void, any Error> {
    fatalError("서버에서 미 구현된 api 입니다.")
  }
  
  func fetchProfile() -> AnyPublisher<UserEntity, any Error> {
    fatalError("서버에서 미 구현된 api 입니다.")
  }
}
