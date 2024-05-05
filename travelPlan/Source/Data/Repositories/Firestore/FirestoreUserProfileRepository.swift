//
//  FirestoreUserProfileRepository.swift
//  travelPlanTests
//
//  Created by 양승현 on 5/5/24.
//

import Combine
import Foundation
import SHFirestoreService

final class FirestoreUserProfileRepository {
  typealias Endpoint = FirestoreUserProfileAPIEndpoint
  
  // MARK: - Dependencies
  private let backgroundQueue: DispatchQueue
  private let service: FirestoreServiceProtocol
  private let firebaseStorageService: ImageStorageServiceProtocol
  
  // MARK: - Properties
  private var subscriptions = Set<AnyCancellable?>()
  
  // MARK: - Lifecycle
  init(
    service: FirestoreServiceProtocol,
    backgroundQueue: DispatchQueue = .global(qos: .userInitiated),
    firebaseStorageService: ImageStorageServiceProtocol
  ) {
    self.service = service
    self.backgroundQueue = backgroundQueue
    self.firebaseStorageService = firebaseStorageService
  }
}

// MARK: - UserProfileRepository
extension FirestoreUserProfileRepository: UserProfileRepository {
  func fetchProfile(with userId: String) -> AnyPublisher<UserEntity, any Error> {
    let endpoint = Endpoint.makeUserProfileFetchEndpoint(userUID: userId)
    return Future { [weak self, backgroundQueue] promise in
      let requestSubscription = self?.service.request(endpoint: endpoint)
        .subscribe(on: backgroundQueue)
        .receive(on: backgroundQueue)
        .sink { completion in
          if case .failure(let error) = completion {
            promise(.failure(error))
          }
        } receiveValue: { responseDTO in
          if responseDTO.profileImagePath == "" {
            let userEntity = responseDTO.toDomain(with: nil)
            promise(.success(userEntity))
            return
          }
          let storageSubscription = self?.firebaseStorageService
            .fetchImage(
              responseDTO.profileImagePath,
              type: .profileImage
            ).sink { completion in
              if case .failure(let error) = completion {
                promise(.failure(error))
              }
            } receiveValue: { imageData in
              let userEntity = responseDTO.toDomain(with: imageData)
              promise(.success(userEntity))
            }
          self?.subscriptions.insert(storageSubscription)
        }
      self?.subscriptions.insert(requestSubscription)
    }.eraseToAnyPublisher()
  }
  
  func fetchProfileImageData(
    with userId: String
  ) -> AnyPublisher<ProfileImageData?, any Error> {
    return Future { [weak self] promise in
      let subscription = self?.fetchProfile(with: userId).sink { completion in
        if case .failure(let error) = completion {
          promise(.failure(error))
        }
      } receiveValue: { userEntity in
        promise(.success(userEntity.profileImageData))
      }
      self?.subscriptions.insert(subscription)
    }.eraseToAnyPublisher()
  }
}
