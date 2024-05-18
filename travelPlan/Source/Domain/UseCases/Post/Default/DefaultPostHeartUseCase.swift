//
//  DefaultPostHeartUseCase.swift
//  travelPlan
//
//  Created by 양승현 on 5/3/24.
//

import Foundation
import Combine

@frozen enum PostHeartUseCaseError: LocalizedError {
  case invalidLoggedInUser
  case invalidReference
}

final class DefaultPostHeartUseCase {
  // MARK: - Dependencies
  private let backgroundQueue: DispatchQueue
  
  private let postHeartRepository: PostHeartRepository
  
  private let loggedInUserRepository: LoggedInUserRepository
  
  // MARK: - Properties
  private var subscriptions = Set<AnyCancellable?>()
  
  // MARK: - Lifecycle
  init(
    backgroundQueue: DispatchQueue,
    postHeartRepository: PostHeartRepository,
    loggedInUserRepository: LoggedInUserRepository
  ) {
    self.backgroundQueue = backgroundQueue
    self.postHeartRepository = postHeartRepository
    self.loggedInUserRepository = loggedInUserRepository
  }
}

// MARK: - PostHeartUseCase
extension DefaultPostHeartUseCase: PostHeartUseCase {
  func fetchPostHearts(
    _ postId: String
  ) -> AnyPublisher<Int, any Error> {
    return postHeartRepository
      .fetchPostHearts(postId)
      .receive(on: backgroundQueue)
      .eraseToAnyPublisher()
  }
  
  func heartPost(
    _ postId: String
  ) -> AnyPublisher<Void, any Error> {
    return Future { [weak self] promise in
      guard let ownerId = self?.loggedInUserRepository.id else {
        promise(.failure(PostHeartUseCaseError.invalidLoggedInUser))
        return
      }
      
      guard let self else {
        promise(.failure(PostHeartUseCaseError.invalidReference))
        return
      }
      
      let group = DispatchGroup()
      
      let heartPostSubscription = postHeartRepository
        .heartPost(postId, userId: ownerId)
        .receive(on: backgroundQueue)
        .sink { completion in
          if case .failure(let error) = completion {
            promise(.failure(error))
          }
        } receiveValue: { _ in
          group.leave()
        }
      subscriptions.insert(heartPostSubscription)
      
      handlePostHeartsUpdate(with: group, usingPostId: postId, willHeartPost: true, promise: promise)
      
      group.notify(queue: backgroundQueue) {
        promise(.success(()))
      }
    }
    .eraseToAnyPublisher()
  }
  
  func hatePost(
    _ postId: String
  ) -> AnyPublisher<Void, any Error> {
    return Future { [weak self] promise in
      guard let ownerId = self?.loggedInUserRepository.id else {
        promise(.failure(PostHeartUseCaseError.invalidLoggedInUser))
        return
      }
      
      guard let self else {
        promise(.failure(PostHeartUseCaseError.invalidReference))
        return
      }
      let group = DispatchGroup()
      
      group.enter()
      let heartPostSubscription = postHeartRepository
        .hatePost(postId, userId: ownerId)
        .receive(on: backgroundQueue)
        .sink { completion in
          if case .failure(let error) = completion {
            promise(.failure(error))
          }
        } receiveValue: { _ in
          group.leave()
        }
      subscriptions.insert(heartPostSubscription)
      
      handlePostHeartsUpdate(with: group, usingPostId: postId, willHeartPost: false, promise: promise)
      
      group.notify(queue: backgroundQueue) {
        promise(.success(()))
      }
    }
    .eraseToAnyPublisher()
  }
}

// MARK: - Private Helpers
private extension DefaultPostHeartUseCase {
  func handlePostHeartsUpdate(
    with group: DispatchGroup,
    usingPostId postId: String,
    willHeartPost: Bool,
    promise: @escaping Future<Void, Error>.Promise
  ) {
    group.enter()
    let togglePostHeartsSubscription = postHeartRepository
      .updatePostHearts(postId, willHeartPost: willHeartPost)
      .receive(on: backgroundQueue)
      .sink { completion in
        if case .failure(let error) = completion {
          promise(.failure(error))
        }
      } receiveValue: { _ in group.leave() }
    subscriptions.insert(togglePostHeartsSubscription)
  }
}
