//
//  FirestoreMyProfileRepository.swift
//  travelPlan
//
//  Created by 양승현 on 4/25/24.
//

import Foundation
import Combine
import SHFirestoreService

final class FirestoreMyProfileRepository {
  typealias Endpoint = FirestoreMyProfileAPIEndopint
  
  // MARK: - Dependencies
  private let backgroundQueue: DispatchQueue
  private let service: FirestoreServiceProtocol
  private let firebaseStorageService: ImageStorageServiceProtocol
  private let loggedInUserRepository: LoggedInUserRepository
  private let imageCache: ImageMemoryCachable
  
  // MARK: - Properties
  private var subscriptions = Set<AnyCancellable?>()
  
  // MARK: - Lifecycle
  init(
    service: FirestoreServiceProtocol,
    loggedInUserRepository: LoggedInUserRepository,
    backgroundQueue: DispatchQueue = .global(qos: .userInitiated),
    firebaseStorageService: ImageStorageServiceProtocol,
    imageCache: ImageMemoryCachable
  ) {
    self.service = service
    self.loggedInUserRepository = loggedInUserRepository
    self.backgroundQueue = backgroundQueue
    self.firebaseStorageService = firebaseStorageService
    self.imageCache = imageCache
  }
}

// MARK: - MyProfileRepository
extension FirestoreMyProfileRepository: MyProfileRepository {
  var isProfileSavedInServer: Bool {
    loggedInUserRepository.isSavedProfileInServer
  }
  
  func fetchProfile(with userId: String) -> AnyPublisher<UserEntity, any Error> {
    let endpoint = Endpoint.fetchUserProfileEndpoint(userUID: userId)
    return Future { [weak self, backgroundQueue] promise in
      let subscription = self?.service.request(endpoint: endpoint)
        .subscribe(on: backgroundQueue)
        .sink { completion in
          if case .failure(let error) = completion {
            promise(.failure(error))
          }
        } receiveValue: { responseDTO in
          promise(.success(responseDTO.toDomain()))
        }
      self?.subscriptions.insert(subscription)
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
