//
//  MockPostRepository.swift
//  travelPlan
//
//  Created by 양승현 on 3/8/24.
//

import Combine
import Foundation

final class MockPostRepository: PostRepository {
  typealias Endpoint = PostAPIEndpoint
  let mockService: Sessionable
  var subscriptions = Set<AnyCancellable?>()
  let postRepository: PostRepository
  
  init() {
    self.mockService = SessionProvider(session: MockSession.default)
    let mockUserStroage = MockUserStorage()
    let defaultLoggedInUserRepository = DefaultLoggedInUserRepository(storage: mockUserStroage)
    self.postRepository = DefaultPostRepository(
      service: mockService,
      loggedInUserRepository: defaultLoggedInUserRepository)
  }
  
  func fetchPosts(
    page: Int32,
    perPage: Int32,
    category: PostCategory
  ) -> AnyPublisher<PostsPage, any Error> {
    MockUrlProtocol.requestHandler = { _ in
      let mockData = MockResponseType.post(.whenPostContainerResponse).mockDataLoader
      return ((HTTPURLResponse(), mockData))
    }
    return Future { promise in
      DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 0.1) { [weak self] in
        let subscription = self?.postRepository
          .fetchPosts(page: page, perPage: perPage, category: category)
          .sink(receiveCompletion: { completion in
            if case .failure(let error) = completion {
              promise(.failure(error))
            }
          }, receiveValue: { postsPage in
            promise(.success(postsPage))
          })
        self?.subscriptions.insert(subscription)
      }
    }.eraseToAnyPublisher()
  }
  
  func fetchComments(
    page: Int32,
    perPage: Int32,
    postId: Int64
  ) -> AnyPublisher<PostCommentContainerEntity, any Error> {
    MockUrlProtocol.requestHandler = { _ in
      let mockData = MockResponseType.post(.whenPostCommentContainerResponse).mockDataLoader
      return ((HTTPURLResponse(), mockData))
    }
    return Future { promise in
      DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 0.1) { [weak self] in
        let subscription = self?.postRepository
          .fetchComments(page: page, perPage: perPage, postId: postId)
          .sink(receiveCompletion: { completion in
            if case .failure(let error) = completion {
              promise(.failure(error))
            }
          }, receiveValue: { postCommentContainerEntity in
            promise(.success(postCommentContainerEntity))
          })
        self?.subscriptions.insert(subscription)
      }
    }.eraseToAnyPublisher()
  }
  
  func fetchLikedPostsByLoggedInUser(
    page: Int32,
    perPage: Int32
  ) -> AnyPublisher<PostsPage, any Error> {
    MockUrlProtocol.requestHandler = { _ in
      let mockData = MockResponseType.post(.whenPostContainerResponse).mockDataLoader
      return ((HTTPURLResponse(), mockData))
    }
    return Future { promise in
      DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 0.1) { [weak self] in
        let subscription = self?.postRepository
          .fetchLikedPostsByLoggedInUser(page: page, perPage: perPage)
          .sink(receiveCompletion: { completion in
            if case .failure(let error) = completion {
              promise(.failure(error))
            }
          }, receiveValue: { postsPage in
            promise(.success(postsPage))
          })
        self?.subscriptions.insert(subscription)
      }
    }.eraseToAnyPublisher()
  }
}
