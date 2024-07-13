//
//  PostRepositoryDecorator.swift
//  travelPlan
//
//  Created by 양승현 on 3/8/24.
//

import Combine
import UIKit

final class PostRepositoryDecorator: PostRepository {
  typealias Endpoint = PostAPIEndpoint
  let mockService: Sessionable
  var subscriptions = Set<AnyCancellable?>()
  let postRepository: PostRepository
  var cache: [String: Data] = [:]
  
  init() {
    self.mockService = SessionProvider(session: MockSession.default)
    let stubOwnerStorage = StubOwnerStorage()
    _ = DefaultLoggedInUserRepository(storage: Dependency(value: stubOwnerStorage))
    self.postRepository = DefaultPostRepository(
      service: mockService,
      ownerStorage: stubOwnerStorage)
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
    return postRepository
      .fetchPosts(page: page, perPage: perPage, category: category)
      .eraseToAnyPublisherWithDelay(for: .seconds(0.0777), scheduler: RunLoop.current)
  }
  
  func fetchComments(
    page: Int32,
    perPage: Int32,
    postId: PostIdentifier
  ) -> AnyPublisher<PostCommentContainerEntity, any Error> {
    MockUrlProtocol.requestHandler = { _ in
      let mockData = MockResponseType.post(.whenPostCommentContainerResponse).mockDataLoader
      return ((HTTPURLResponse(), mockData))
    }
    return postRepository
      .fetchComments(page: page, perPage: perPage, postId: postId)
      .eraseToAnyPublisherWithDelay(for: .seconds(0.07), scheduler: RunLoop.current)
  }
  
  func fetchLikedPostsByLoggedInUser(
    page: Int32,
    perPage: Int32
  ) -> AnyPublisher<PostsPage, any Error> {
    MockUrlProtocol.requestHandler = { _ in
      let mockData = MockResponseType.post(.whenPostContainerResponse).mockDataLoader
      return ((HTTPURLResponse(), mockData))
    }
    return postRepository.fetchLikedPostsByLoggedInUser(page: page, perPage: perPage)
  }
  
  func searchPosts(
    keyword: String,
    page: Int32,
    perPage: Int32,
    isTitle: Bool,
    isContent: Bool
  ) -> AnyPublisher<[Post], any Error> {
    MockUrlProtocol.requestHandler = { _ in
      let mockData = MockResponseType.post(.whenPostsSearchResponse).mockDataLoader
      return ((.init(), mockData))
    }
    return postRepository
      .searchPosts(keyword: keyword, page: page, perPage: perPage, isTitle: isTitle, isContent: isContent)
      .eraseToAnyPublisherWithDelay(for: .seconds(0.06), scheduler: RunLoop.current)
  }
  
  func togglePostHeart(postId: Int64) -> AnyPublisher<Bool, any Error> {
    MockUrlProtocol.requestHandler = { _ in
      let mock = MockResponseType.postComment(.whenCommentHeartToggle).mockDataLoader
      return ((HTTPURLResponse(), mock))
    }
    return postRepository
      .togglePostHeart(postId: 777)
      .eraseToAnyPublisherWithDelay(for: .seconds(0.06), scheduler: RunLoop.current)
  }
}
