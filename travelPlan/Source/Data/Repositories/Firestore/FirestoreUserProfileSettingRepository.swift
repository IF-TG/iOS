//
//  FirestoreUserProfileSettingRepository.swift
//  travelPlan
//
//  Created by 양승현 on 4/25/24.
//

import Foundation
import Combine
import SHFirestoreService

final class FirestoreUserProfileSettingRepository {
  typealias Endpoint = FirestoreUserProfileSettingAPIEndopint
  
  // MARK: - Dependencies
  private let backgroundQueue: DispatchQueue
  private let service: FirestoreServiceProtocol
  private let firebaseStorageService: ImageStorageServiceProtocol
  private let ownerStorage: OwnerStorage
  /// 프로필 이미지 받을때 disk보다 memory cache가 더 빨리 가져옵니다.
  private let imageCache: ImageMemoryCachable
  
  // MARK: - Properties
  private var subscriptions = Set<AnyCancellable?>()
  
  // MARK: - Lifecycle
  init(
    service: FirestoreServiceProtocol,
    firebaseStorageService: ImageStorageServiceProtocol,
    backgroundQueue: DispatchQueue = .global(qos: .userInitiated),
    ownerStorage: OwnerStorage,
    imageCache: ImageMemoryCachable
  ) {
    self.service = service
    self.ownerStorage = ownerStorage
    self.backgroundQueue = backgroundQueue
    self.firebaseStorageService = firebaseStorageService
    self.imageCache = imageCache
  }
}

// MARK: - MyProfileRepository
extension FirestoreUserProfileSettingRepository: UserProfileSettingRepository {
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
        } receiveValue: { [weak self] _ in
          let ownerEntity = UserEntity(
            id: userId,
            nickname: nickname,
            profileImageData: profileImageData,
            isSavedProfileInServer: true)
          self?.ownerStorage.setUser(with: ownerEntity)
          promise(.success(()))
        }
        subscriptions.insert(saveSubscription)
      }
      subscriptions.insert(subscription)
    }.eraseToAnyPublisher()
  }
  
  func checkIfUserNicknameDuplicate(with name: String) -> AnyPublisher<Bool, any Error> {
    let endpoint = Endpoint.makeNicknameIsDuplicatedEndpoint()
    return Future { [weak self, backgroundQueue] promise in
      let subscription = self?.service
        .isDocumentExists(endpoint: endpoint) { collectionRef in
          return collectionRef.whereField("nickname", isEqualTo: "name")
        }.receive(on: backgroundQueue)
        .sink { completion in
          if case .failure(let error) = completion {
            promise(.failure(error))
          }
        } receiveValue: { isNicknameDuplicated in
          promise(.success(isNicknameDuplicated))
        }
      self?.subscriptions.insert(subscription)
    }.eraseToError()
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
}

// MARK: - Private Helpers
extension FirestoreUserProfileSettingRepository {
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
        } receiveValue: { [weak self] _ in
          self?.ownerStorage.updateNickname(with: nickname)
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
