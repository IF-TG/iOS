//
//  FirestoreUserBlockRepository.swift
//  travelPlan
//
//  Created by 양승현 on 5/18/24.
//

import Combine
import Foundation
import SHFirestoreService

final class FirestoreUserBlockRepository {
  typealias Endpoint = FirestoreUserBlockAPIEndpoint
  
  // MARK: - Dependencies
  private let service: FirestoreServiceProtocol
  
  private let ownerStorage: OwnerStorage
  
  // MARK: - Properties
  private var subscriptions = Set<AnyCancellable?>()
  
  private let backgroundQueue: DispatchQueue
  
  // MARK: - Lifecycle
  init(
    service: FirestoreServiceProtocol,
    ownerStorage: OwnerStorage,
    backgroundQueue: DispatchQueue = DispatchQueue(
      label: "com.yeoga.app.UserBlockRepository.queue",
      qos: .default,
      attributes: .concurrent)
  ) {
    self.service = service
    self.ownerStorage = ownerStorage
    self.backgroundQueue = backgroundQueue
  }
}

// MARK: - UserBlockRepository
extension FirestoreUserBlockRepository: UserBlockRepository {
  /// 서버에 사용자를 차단하고,
  /// 로컬에 저장합니다.
  func blockUser(
    with userId: UserIdentifier
  ) -> AnyPublisher<BlockedUserIdentifyEntity, any Error> {
    guard let ownerId = ownerStorage.id else {
      return Fail(error: OwnerError.invalidOwnerId).eraseToAnyPublisher()
    }
    let endpoint = Endpoint.makeUserBlockEndpoint(
      ownerId: ownerId,
      willBlockedUserId: userId)
    return Future { [weak self] promise in
      guard let self else {
        promise(.failure(ReferenceError.invalidReference))
        return
      }
      let blockSubscription = service
        .saveDocument(endpoint: endpoint)
        .receive(on: backgroundQueue)
        .sink { completion in
          if case .failure(let error) = completion {
            promise(.failure(error))
          }
        } receiveValue: { [weak self] _ in
          let entity = BlockedUserIdentifyEntity(userId: userId, isBlocked: true)
          self?.ownerStorage.addBlockedUser(with: userId)
          promise(.success(entity))
        }
      subscriptions.insert(blockSubscription)
    }.eraseToAnyPublisher()
  }
  
  /// 차단된 사용자를 서버에 접근해 해제하고, 로컬에도 해제합니다.
  func unblockUser(
    with blockedUserId: UserIdentifier
  ) -> AnyPublisher<Void, any Error> {
    guard let ownerId = ownerStorage.id else {
      return Fail(error: OwnerError.invalidOwnerId).eraseToAnyPublisher()
    }
    
    let endpoint = Endpoint.makeBlockedUserUnblockEndpoint(ownerId: ownerId, blockedUserId: blockedUserId)
    return Future { [weak self] promise in
      guard let self else {
        promise(.failure(ReferenceError.invalidReference))
        return
      }
      
      let unblockSubscription = service
        .request(endpoint: endpoint)
        .receive(on: backgroundQueue)
        .map { [weak self] _ in
          self?.ownerStorage.deleteBlockedUser(with: blockedUserId)
          return ()
        }
        .sink(promise: promise)
      subscriptions.insert(unblockSubscription)
    }.eraseToAnyPublisher()
  }
  
  /// 로컬에 차단된 사용자 리스트가 있을 경우 차단한 사용자들을 불러옵니다. 
  /// 차단된 사용자가 없는 경우 최초 로그인한 사용자임으로 서버에서 사용자 리스트를 받아옵니다.
  func fetchBlockedUsers(
  ) -> AnyPublisher<[BlockedUserIdentifyEntity], any Error> {
    if ownerStorage.blockedUsers.count > 0 {
      return Just(
        makeBlockedUserIdentifiers(from: ownerStorage.blockedUsers)
      ).setAnyErrorAndEraseToAnyPublisher()
    }
    
    guard let ownerId = ownerStorage.id else {
      return Fail(error: OwnerError.invalidOwnerId).eraseToAnyPublisher()
    }
    
    let endpoint = Endpoint.makeBlockedUsersFetchEndpoint(ownerId: ownerId)
    return Future { [weak self, backgroundQueue] promise in
      let BlockedUsersFetchSubscription = self?.service
        .retrieveDocumentIDs(endpoint: endpoint)
        .receive(on: backgroundQueue)
        .sink { completion in
          if case .failure(let error) = completion {
            promise(.failure(error))
          }
        } receiveValue: { [weak self] blockedUsers in
          // MARK: 현재 firestore가 아닌 spring server를 이용하기에, -1을 대입합니다.
          blockedUsers.forEach { self?.ownerStorage.addBlockedUser(with: UserIdentifier($0) ?? -1) }
          promise(.success(
            self?.makeBlockedUserIdentifiers(from: blockedUsers.map { UserIdentifier($0) ?? -1 }) ?? []))
        }
      self?.subscriptions.insert(BlockedUsersFetchSubscription)
    }.eraseToAnyPublisher()
  }
}

// MARK: - Private Helpers
private extension FirestoreUserBlockRepository {
  func makeBlockedUserIdentifiers(
    from blockedUsers: [UserIdentifier]
  ) -> [BlockedUserIdentifyEntity] {
    return blockedUsers.map { BlockedUserIdentifyEntity(userId: $0, isBlocked: true) }
  }
}
