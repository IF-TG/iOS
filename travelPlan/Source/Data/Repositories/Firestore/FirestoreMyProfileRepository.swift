//
//  FirestoreMyProfileRepository.swift
//  travelPlan
//
//  Created by 양승현 on 4/25/24.
//

import Foundation
import Combine
import SHFirestoreService

@frozen enum FirestoreMyProfileRepositoryError: LocalizedError {
  case invaildOwnerId
}

final class FirestoreMyProfileRepository {
  typealias Endpoint = FirestoreMyProfileAPIEndopint
  
  // MARK: - Dependencies
  private let backgroundQueue: DispatchQueue
  private let service: FirestoreServiceProtocol
  private let userProfileRepository: UserProfileRepository
  private let firebaseStorageService: ImageStorageServiceProtocol
  private let ownerStorage: OwnerStorage
  private let imageCache: ImageMemoryCachable
  
  // MARK: - Properties
  private var subscriptions = Set<AnyCancellable?>()
  
  // MARK: - Lifecycle
  init(
    service: FirestoreServiceProtocol,
    ownerStorage: OwnerStorage,
    userProfileRepository: UserProfileRepository,
    backgroundQueue: DispatchQueue = .global(qos: .userInitiated),
    firebaseStorageService: ImageStorageServiceProtocol,
    imageCache: ImageMemoryCachable
  ) {
    self.service = service
    self.ownerStorage = ownerStorage
    self.backgroundQueue = backgroundQueue
    self.firebaseStorageService = firebaseStorageService
    self.userProfileRepository = userProfileRepository
    self.imageCache = imageCache
  }
}

// MARK: - MyProfileRepository
extension FirestoreMyProfileRepository: UserProfileSettingRepository {
  var isProfileSavedInServer: Bool {
    ownerStorage.isSavedProfileInServer
  }
  
  func fetchProfile() -> AnyPublisher<UserEntity, any Error> {
    if let user = ownerStorage.user {
      return Just(user)
        .setFailureType(to: ReferenceError.self)
        .mapError { $0 as Error }
        .eraseToAnyPublisher()
    }
    return Future { [weak self, backgroundQueue] promise in
      guard let ownerId = self?.ownerStorage.id else {
        promise(.failure(FirestoreMyProfileRepositoryError.invaildOwnerId))
        return
      }
      let subscription = self?.userProfileRepository
        .fetchProfile(with: ownerId)
        .subscribe(on: backgroundQueue)
        .receive(on: backgroundQueue)
        .sink { completion in
          if case .failure(let error) = completion {
            promise(.failure(error))
          }
        } receiveValue: { userEntity in
          self?.ownerStorage.setUser(with: userEntity)
          promise(.success(userEntity))
        }
      self?.subscriptions.insert(subscription)
    }.eraseToAnyPublisher()
  }
  
  func saveProfile(
    with userId: String,
    nickname: String,
    profileImageData: Data
  ) -> AnyPublisher<Void, any Error> {
    guard profileImageData.count > 0 else {
      return saveProfileWithoutProfileImage(with: userId, nickname: nickname)
    }
    
    return Future { [weak self] promise in
      guard let self else {
        promise(.failure(ReferenceError.invalidReference))
        return
      }
      let subscription = uploadProfileImage(profileImageData).sink { completion in
        if case .failure(let error) = completion {
          promise(.failure(error))
        }
      } receiveValue: { [weak self] profileImageUrl in
        guard let self else {
          promise(.failure(ReferenceError.invalidReference))
          return
        }
        let saveSubscription = saveProfileWithProfileImage(
          userId: userId,
          nickname: nickname,
          imageUrl: profileImageUrl
        ).sink { completion in
          if case .failure(let error) = completion { promise(.failure(error)) }
        } receiveValue: { promise(.success($0)) }
        subscriptions.insert(saveSubscription)
      }
      subscriptions.insert(subscription)
    }.eraseToAnyPublisher()
  }
  
  func checkIfUserNicknameDuplicate(with name: String) -> AnyPublisher<Bool, any Error> {
    fatalError("아직 미구현")
  }
  
  func updateUserNickname(with name: String) -> AnyPublisher<Bool, any Error> {
    fatalError("아직 미구현")
  }
  
  func updateProfileImage(with profile: String) -> AnyPublisher<Bool, any Error> {
    fatalError("아직 미구현")
  }
  
  func saveProfileImage(with profile: String) -> AnyPublisher<Bool, any Error> {
    fatalError("아직 미구현")
  }
  
  func deleteProfileImage() -> AnyPublisher<Bool, any Error> {
    fatalError("아직 미구현")
  }
  
  func fetchProfileImage() -> AnyPublisher<ProfileImageEntity, any Error> {
    fatalError("아직 미구현")
  }
}

// MARK: - Private Helpers
extension FirestoreMyProfileRepository {
  private func saveProfileWithoutProfileImage(with userId: String, nickname: String) -> AnyPublisher<Void, Error> {
    let requestDTO = UserProfileSaveRequestDTO(
      uid: userId,
      nickname: nickname,
      profileImagePath: ""
    )
    let endpoint = Endpoint.saveUserProfileEndpoint(with: requestDTO)
    return Future { [weak self] promise in
      let subscription = self?.service.request(endpoint: endpoint)
        .sink { completion in
          if case .failure(let error) = completion {
            promise(.failure(error))
          }
        } receiveValue: { _ in
          promise(.success(()))
        }
      self?.subscriptions.insert(subscription)
    }.eraseToAnyPublisher()
  }
  
  private func uploadProfileImage(_ imageData: Data) -> AnyPublisher<String, Error> {
    return firebaseStorageService.uploadImage(imageData, type: .profileImage)
      .eraseToAnyPublisher()
  }
  
  private func saveProfileWithProfileImage(
    userId: String,
    nickname: String,
    imageUrl: String
  ) -> AnyPublisher<Void, Error> {
    let requestDTO = UserProfileSaveRequestDTO(
      uid: userId,
      nickname: nickname,
      profileImagePath: imageUrl
    )
    let endpoint = Endpoint.saveUserProfileEndpoint(with: requestDTO)
    return service.request(endpoint: endpoint)
      .mapError { $0 as Error }
      .eraseToAnyPublisher()
  }
}
