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
  func fetchHeartUsers(
    _ postId: String
  ) -> AnyPublisher<[String], any Error> {
    return postHeartRepository
      .fetchHeartUsers(postId)
      .eraseToAnyPublisher()
  }
  
  func fetchPostHearts(
    _ postId: String
  ) -> AnyPublisher<Int, any Error> {
    return postHeartRepository
      .fetchPostHearts(postId)
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
      
      let identifier = BackgroundTaskManager.shared.startBackgroundTask()
      let group = DispatchGroup()
      
      let heartPostSubscription = postHeartRepository
        .heartPost(postId, userId: ownerId)
        .sink { completion in
          if case .failure(let error) = completion {
            promise(.failure(error))
            group.leave()
          }
        } receiveValue: { _ in
          group.leave()
        }
      subscriptions.insert(heartPostSubscription)
      
      group.enter()
      let togglePostHeartsSubscription = postHeartRepository
        .togglePostHearts(postId, willHeartPost: true)
        .sink { completion in
          if case .failure(let error) = completion {
            promise(.failure(error))
            group.leave()
          }
        } receiveValue: { _ in
          group.leave()
        }
      subscriptions.insert(togglePostHeartsSubscription)
      group.notify(queue: backgroundQueue) {
        promise(.success(()))
        BackgroundTaskManager.shared.endBackgroundTask(identifier)
      }
    }
    .subscribe(on: backgroundQueue)
    .receive(on: backgroundQueue)
    .eraseToAnyPublisher()
  }
  
  func hatePost(
    _ postId: String
  ) -> AnyPublisher<Void, any Error> {
    fatalError("미구현")
  }
}
