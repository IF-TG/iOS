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
    
    // MARK: - 이 시점은 mock json에 base64이미지 str이 담긴게 아니라 에셋에 있는 이미지 경로를 담았기에 포스트 상세 화면에서
    // 댓글, 대댓글 작성자 이미지는 nil이 됩니다.
    return postRepository
      .fetchComments(page: page, perPage: perPage, postId: postId)
      .map { [weak self] postCommentContainerEntity in
        let json파일에asset경로다시한번UIImage_named_로변환한데이터 = postCommentContainerEntity
          .comments.map {
            let str = $0.userProfileImageData!.base64EncodedString()
            if self?.cache[str] == nil {
              self?.cache[str] = UIImage(named: str)?.jpegData(compressionQuality: 1)
            }
            let commentUserImage = self?.cache[str]
            let nestedCommentUserImages = $0.nestedComments.map {
              let nStr = $0.userProfileImageData!.base64EncodedString()
              if self?.cache[nStr] == nil {
                self?.cache[nStr] = UIImage(named: nStr)?.jpegData(compressionQuality: 1)
              }
              return self?.cache[nStr]
            }
            return PostCommentEntity(
              commentId: $0.commentId,
              authorId: $0.authorId,
              userProfileImageData: commentUserImage,
              userName: $0.userName,
              timestamp: $0.timestamp,
              comment: $0.comment,
              isDeleted: $0.isDeleted,
              isOnHeart: $0.isOnHeart,
              isBlocked: $0.isBlocked,
              hearts: $0.hearts,
              nestedComments: $0.nestedComments.enumerated().map { i, nestedComment in
                PostNestedCommentEntity(
                  nestedCommentId: nestedComment.nestedCommentId,
                  authorId: nestedComment.authorId,
                  userProfileImageData: nestedCommentUserImages[i],
                  nickname: nestedComment.nickname,
                  timestamp: nestedComment.timestamp,
                  comment: nestedComment.comment,
                  hearts: nestedComment.hearts,
                  isOnHeart: nestedComment.isOnHeart)
              })
          }
        return PostCommentContainerEntity(
          comments: json파일에asset경로다시한번UIImage_named_로변환한데이터,
          isFavorited: postCommentContainerEntity.isFavorited)
      }
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
