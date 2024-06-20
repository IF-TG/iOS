//
//  MockPostRepository.swift
//  travelPlan
//
//  Created by 양승현 on 3/8/24.
//

import Combine
import UIKit

final class MockPostRepository: PostRepository {
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
  
  // swiftlint:disable:next function_body_length
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
    return Future { promise in
      DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 0.1) { [weak self] in
        let subscription = self?.postRepository
          .fetchComments(page: page, perPage: perPage, postId: postId)
          .sink(receiveCompletion: { completion in
            if case .failure(let error) = completion {
              promise(.failure(error))
            }
          }, receiveValue: { postCommentContainerEntity in
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
            promise(.success(.init(
              comments: json파일에asset경로다시한번UIImage_named_로변환한데이터,
              isFavorited: postCommentContainerEntity.isFavorited)))
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
    return Future { promise in
      DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 0.05) { [weak self] in
        let subscription = self?.postRepository
          .searchPosts(keyword: keyword, page: page, perPage: perPage, isTitle: isTitle, isContent: isContent)
          .sink { completion in
            if case .failure(let error) = completion {
              promise(.failure(error))
            }
          } receiveValue: { posts in
            promise(.success(posts))
          }
        self?.subscriptions.insert(subscription)
      }
    }.eraseToAnyPublisher()
  }
  
}
