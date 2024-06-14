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
  private let service: FirestoreServiceProtocol
  
  private let firebaseStorageService: ImageStorageServiceProtocol
  
  private let ownerStorage: OwnerStorage
  
  private let backgroundQueue: DispatchQueue
  
  // MARK: - Properties
  private var subscriptions = Set<AnyCancellable?>()
  
  // MARK: - Lifecycle
  init(
    service: FirestoreServiceProtocol,
    firebaseStorageService: ImageStorageServiceProtocol,
    ownerStorage: OwnerStorage,
    backgroundQueue: DispatchQueue = .global(qos: .userInitiated)
  ) {
    self.service = service
    self.ownerStorage = ownerStorage
    self.backgroundQueue = backgroundQueue
    self.firebaseStorageService = firebaseStorageService
  }
}

// MARK: - MyProfileRepository
extension FirestoreUserProfileSettingRepository: UserProfileSettingRepository {
  /// 프로필을 Firebase's firestore 및 storage에 저장합니다
  ///
  /// Notes:
  /// 1. profileImageData가 없는 경우
  ///     - Storage를 사용하지 않고 firestore에 user's collection에 userId를 문서id로 문서를 저장합니다.
  ///     - 저장에 성공하면 disk cache에 저장합니다.
  /// 2. profileImageData가 있는 경우
  ///     - Firebase stroage에 프로필을 저장합니다.
  ///     - 해당 storage에 저장된 path를 받아와서 firestore에 user's collection에 userId를 문서 id로 문서를 저장합니다.
  func saveProfile(
    with userId: String,
    nickname: String,
    profileImageData: Data?
  ) -> AnyPublisher<Void, any Error> {
    guard let profileImageData = profileImageData, profileImageData.count > 0 else {
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
        ).receive(on: backgroundQueue)
          .sink(promise: promise) { [weak self] _ in
            let ownerEntity = UserEntity(
              id: userId,
              nickname: nickname,
              profileImageUrl: profileImageUrl,
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
  
  /// 주어진 이름을 가진 사용자가 존재하는지 duplicate 검사를 합니다.
  func checkIfUserNicknameDuplicate(with name: String) -> AnyPublisher<Bool, any Error> {
    let endpoint = Endpoint.makeNicknameIsDuplicatedEndpoint()
    return Future { [weak self, backgroundQueue] promise in
      let subscription = self?.service
        .isDocumentExists(endpoint: endpoint) { collectionRef in
          return collectionRef.whereField("nickname", isEqualTo: "\(name)")
        }.receive(on: backgroundQueue)
        .eraseToError()
        .sink(promise: promise) { isNicknameDuplicated in
          promise(.success(isNicknameDuplicated))
        }
      self?.subscriptions.insert(subscription)
    }.eraseToAnyPublisher()
  }
  
  /// 사용자의 이름을 업데이트합니다.
  ///
  /// Notes:
  /// 1. 사용자의 이름을 firestore의 ownerID를 문서id로한 문서의 이름 필드를 수정합니다.
  /// 2. 성공적으로 저장되면 disk cache에 반영합니다.
  func updateUserNickname(with name: String) -> AnyPublisher<Bool, any Error> {
    return Future { [weak self, backgroundQueue] promise in
      guard let ownerId = self?.ownerStorage.id else {
        promise(.failure(OwnerError.invalidOwnerId))
        return
      }
      let requestDTO = UserNicknameRequestDTO(nickname: name)
      let endpoint = Endpoint.makeNicknameUpdateEndpoint(ownerId: ownerId, with: requestDTO)
      let subscription = self?.service
        .request(endpoint: endpoint)
        .receive(on: backgroundQueue)
        .eraseToError()
        .map { _ in return true }
        .sink(promise: promise) {[weak self] result in
          self?.ownerStorage.updateNickname(with: name)
          promise(.success(result))
        }
      self?.subscriptions.insert(subscription)
    }.eraseToAnyPublisher()
  }
  
  /// 사용자의 프로필 이미지를 업데이트합니다.
  ///
  /// Notes:
  /// 1. 사용자의 프로필이 저장되어있지 않은 경우
  ///     - saveProfileImage(with:)로 서버 및 캐싱합니다.
  /// 2. 기존 사용자 프로필이 있는 경우
  ///     - storage에 사용자 프로필을 제거하고 local cache에 사요자 프로필 data, path를 삭제합니다.
  ///     - saveProfileImage(with:)를 수행합니다.
  func updateProfileImage(with profileImageData: Data) -> AnyPublisher<Bool, any Error> {
    guard let ownerEntity = ownerStorage.user else {
      return Fail(error: OwnerError.invalidOwnerId).eraseToAnyPublisher()
    }
    
    if ownerEntity.profileImageUrl == "" {
      return saveProfileImage(with: profileImageData)
    }
    
    return deleteProfileImage()
      .receive(on: backgroundQueue)
      .filter { $0 }
      .flatMap { [weak self] _ -> AnyPublisher<Bool, any Error> in
        guard let self else {
          return Fail(error: ReferenceError.invalidReference).eraseToAnyPublisher()
        }
        return saveProfileImage(with: profileImageData)
      }.eraseToAnyPublisher()
  }
  
  /// 프로필 이미지를 저장합니다.
  ///
  /// Notes:
  /// 1. 프로필을 Firebase storage에 저장하고 그 결과로 profile url path, data를 로컬 유저디폴츠에 저장합니다. 그리고 결과를 반환합니다.
  /// 2. Firebase storage에 owner 이미지가 저장되어있는지는 파악하지 않고 그냥 주어진 데이터를 기반으로 Firebase storage에 ownerId를 경로로 저장합니다.
  func saveProfileImage(with profileImageData: Data) -> AnyPublisher<Bool, any Error> {
    return Future<Bool, any Error> { [weak self] promise in
      guard let self else {
        promise(.failure(ReferenceError.invalidReference))
        return
      }
      
      guard let ownerEntity = ownerStorage.user else {
        promise(.failure(OwnerError.invalidOwnerId))
        return
      }
      
      let subscription = uploadProfileImage(profileImageData)
        .flatMap { [weak self] profileImageUrl -> AnyPublisher<Bool, any Error> in
          guard let self else {
            return Fail(error: ReferenceError.invalidReference).eraseToAnyPublisher()
          }
          ownerStorage.updateProfileImagePath(with: profileImageUrl)
          ownerStorage.updateProfileImageData(with: profileImageData)
          
          let endpoint = Endpoint.makeProfileImageUpdateEndpoint(ownerId: ownerEntity.id, with: profileImageUrl)
          
          return service.request(endpoint: endpoint)
            .map { _ in return true }
            .eraseToError()
        }
        .sink(promise: promise) { result in
          promise(.success(result))
        }
      subscriptions.insert(subscription)
    }.eraseToAnyPublisher()
  }
  
  /// Firestore storage로부터 owner 프로필 이미지를 제거합니다.
  ///
  /// Notes:
  /// 1. 이미지 저장소에서부터 이미지를 제거하고, 사용자 문서에서 프로필 url 필드를 ""로 삭제합니다.
  ///     - cf. 파이어스토어에서는 옵셔널이 존재하지 않기에 삭제됬음을  ""로 대체합니다.
  func deleteProfileImage() -> AnyPublisher<Bool, any Error> {
    guard let ownerEntity = ownerStorage.user else {
      return Fail(error: OwnerError.invalidOwnerId).eraseToAnyPublisher()
    }
    
    let ownerProfileImageUrl = ownerEntity.profileImageUrl
    
    if ownerProfileImageUrl == "" {
      return Just(true).setAnyErrorAndEraseToAnyPublisher()
    }
    
    return Future { [weak self] promise in
      guard let self else {
        promise(.failure(ReferenceError.invalidReference))
        return
      }
      
      let endpoint = Endpoint.makeProfileImageDeleteEndpoint(ownerId: ownerEntity.id)
      
      let subscription = Publishers
        .Zip(
          deleteProfileImage(ownerProfileImageUrl),
          service.request(endpoint: endpoint).eraseToError())
        .receive(on: backgroundQueue)
        .eraseToAnyPublisher()
        .map { _ in true }
        .sink(promise: promise) { [weak self] result in
          self?.ownerStorage.deleteProfileImageData()
          self?.ownerStorage.updateProfileImagePath(with: "")
          promise(.success(result))
        }
      subscriptions.insert(subscription)
    }.eraseToAnyPublisher()
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
      let subscription = self?.service.saveDocument(endpoint: endpoint)
        .eraseToError()
        .map { _ in () }
        .sink(promise: promise) { [weak self] _ in
          self?.ownerStorage.updateNickname(with: nickname)
          promise(.success(()))
        }
      self?.subscriptions.insert(subscription)
    }.eraseToAnyPublisher()
  }
  
  private func uploadProfileImage(_ imageData: Data) -> AnyPublisher<String, Error> {
    return firebaseStorageService.uploadImage(imageData, type: .profileImage)
  }
  
  private func deleteProfileImage(_ imageUrl: String) -> AnyPublisher<Void, Error> {
    return firebaseStorageService.deleteImage(imageUrl, type: .profileImage)
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
    return service.saveDocument(endpoint: endpoint)
      .map { _ in () }
      .eraseToError()
  }
}
