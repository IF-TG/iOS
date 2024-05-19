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
        .sink { completion in
          if case .failure(let error) = completion {
            promise(.failure(error))
          }
        } receiveValue: { _ in
          promise(.success(true))
        }
      self?.subscriptions.insert(subscription)
    }.eraseToAnyPublisher()
  }
  
  func updateProfileImage(with profileImageData: Data) -> AnyPublisher<Bool, any Error> {
    guard let ownerEntity = ownerStorage.user else {
      return Fail(error: OwnerError.invalidOwnerId).eraseToAnyPublisher()
    }
    
    if ownerEntity.profileImageUrl == "" {
      return saveProfileImage(with: profileImageData)
    }
    
    // 여기서는 기존 이미지 저장소에서 삭제한 후에. 다시 그가해야함
    // TODO: - 사용자 업데이트하기전에, 이미지 저장소에서 삭제 -> 다시 저장 후 이 문서 업데이트하는 함수 호출해야함돠.
    fatalError("미구현")
    return Future { [weak self, backgroundQueue] promise in
      
      var urlPath = "" //이미지 넣고 이거기반으로 프로필 필드 업 데이트해야함 저장해야함.
      let requestDict = ["profileImagePath": urlPath]
      let endpoint = Endpoint.makeProfileImageUpdateEndpoint(ownerId: ownerId, with: requestDict)
      let subscription = self?.service
        .request(endpoint: endpoint)
        .receive(on: backgroundQueue)
        .sink { completion in
          if case .failure(let error) = completion {
            promise(.failure(error))
          }
        } receiveValue: { _ in
          promise(.success(true))
        }
      self?.subscriptions.insert(subscription)
    }.eraseToAnyPublisher()
  }
  
  /// 프로필을 Firebase storage에 저장하고
  /// 그 결과로 profile url path, data를 로컬 유저디폴츠에 저장합니다. 그리고 결과를 반환합니다.
  /// Firebase storage에 owner 이미지가 저장되어있는지는 파악하지 않고 그냥 주어진 데이터를 기반으로 Firebase storage에 ownerId를 경로로 저장합니다.
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
        }.eraseToAnyPublisher()
        .sink { completion in
          if case .failure(let error) = completion {
            promise(.failure(error))
          }
        } receiveValue: { result in
          promise(.success(result))
        }
      subscriptions.insert(subscription)
    }.eraseToAnyPublisher()
  }
  
  /// 이미지 저장소에서부터 이미지를 제거하고, 사용자 문서에서 프로필 url 필드를 ""로 삭제합니다.
  /// 파이어스토어에서는 옵셔널이 존재하지 않기에 삭제됬음을  ""로 대체합니다.
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
        .sink { completion in
          if case .failure(let error) = completion {
            promise(.failure(error))
          }
        } receiveValue: { [weak self] _ in
          self?.ownerStorage.deleteProfileImageData()
          self?.ownerStorage.updateProfileImagePath(with: "")
          promise(.success(true))
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
    return service.request(endpoint: endpoint)
      .mapError { $0 as Error }
      .eraseToAnyPublisher()
  }
}
