//
//  MockPostCommentRepository.swift
//  travelPlan
//
//  Created by 양승현 on 3/23/24.
//

import Foundation
import Combine

/// 기본 동작 레포지토리에  mockSession을 통해 mock 데이터를 주입한 Wrapped객체입니다.
final class MockPostCommentRepository: PostCommentRepository {
  let mockService: Sessionable
  var subscriptions = Set<AnyCancellable?>()
  
  let repository: PostCommentRepository
  
  init() {
    self.mockService = SessionProvider(session: MockSession.default)
    self.repository = DefaultPostCommentRepository(service: mockService)
  }
}

extension MockPostCommentRepository {
  func sendComment(
    postId: String,
    comment: String
  ) -> AnyPublisher<PostCommentEntity, any Error> {
    MockUrlProtocol.requestHandler = { _ in
      let mockData = MockResponseType.postComment(.whenCommentSend).mockDataLoader
      return ((HTTPURLResponse(), mockData))
    }
    return Future { promise in
      DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 0.05) { [weak self] in
        let subscription = self?.repository.sendComment(postId: postId, comment: comment)
          .sink { completion in
            if case .failure(let error) = completion {
              promise(.failure(error))
            }
          } receiveValue: { postCommentEntity in
            // 이 시점에 이미 서버의 response data를 encodable -> 관련 entity로 mapping했기에 여기서
            // 잠깐 사용자가 보냈던 comment로 가로체겠습니다.
            let intereceptedEntity = PostCommentEntity(
              commentId: postCommentEntity.commentId,
              authorId: postCommentEntity.authorId,
              userProfileImageData: postCommentEntity.userProfileImageData,
              userName: postCommentEntity.userName,
              timestamp: postCommentEntity.timestamp,
              comment: comment,
              isDeleted: false,
              isOnHeart: false,
              isBlocked: false,
              hearts: 0,
              nestedComments: [])
            promise(.success(intereceptedEntity))
          }
        self?.subscriptions.insert(subscription)
      }
    }.eraseToAnyPublisher()
  }
  
  func updateComment(
    postId: String? = nil,
    commentId: String,
    comment: String
  ) -> AnyPublisher<Bool, any Error> {
    return Future { promise in
      promise(.success(true))
    }.eraseToAnyPublisher()
  }
  
  func deleteComment(
    postId: String? = nil,
    commentId: String
  ) -> AnyPublisher<Bool, any Error> {
    MockUrlProtocol.requestHandler = { _ in
      let mock = MockResponseType.postComment(.whenCommentDelete).mockDataLoader
      return ((HTTPURLResponse(), mock))
    }
    return Future { promise in
      DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 0.05) { [weak self] in
        let subscription = self?.repository.deleteComment(postId: postId, commentId: commentId)
          .sink { completion in
            if case .failure(let error) = completion {
              promise(.failure(error))
            }
          } receiveValue: { result in
            promise(.success(result))
          }
        self?.subscriptions.insert(subscription)
      }
    }.eraseToAnyPublisher()
  }
  
  func fetchComments(
    page: Int32,
    perPage: Int32,
    postId: String
  ) -> AnyPublisher<[PostCommentEntity], any Error> {
    MockUrlProtocol.requestHandler = { _ in
      let mock = MockResponseType.postComment(.whenCommentsFetch).mockDataLoader
      return ((HTTPURLResponse(), mock))
    }
    return Future { promise in
      DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 0.05) { [weak self] in
        let subscription = self?.repository
          .fetchComments(page: page, perPage: perPage, postId: postId)
          .sink { completion in
            if case .failure(let error) = completion {
              promise(.failure(error))
            }
          } receiveValue: { postCommentEntities in
            promise(.success(postCommentEntities))
          }
        self?.subscriptions.insert(subscription)
      }
    }.eraseToAnyPublisher()
  }
  
  func toggleCommentHeart(
    postId: String?,
    commentId: String
  ) -> AnyPublisher<ToggledPostCommentHeartEntity, any Error> {
    MockUrlProtocol.requestHandler = { _ in
      let mock = MockResponseType.postComment(.whenCommentHeartToggle).mockDataLoader
      return ((HTTPURLResponse(), mock))
    }
    return Future { promise in
      DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 0.05) { [weak self] in
        let subscription = self?.repository
          .toggleCommentHeart(postId: postId, commentId: commentId)
          .sink { completion in
            if case .failure(let error) = completion {
              promise(.failure(error))
            }
          } receiveValue: { entity in
            promise(.success(entity))
          }
        self?.subscriptions.insert(subscription)
      }
    }.eraseToAnyPublisher()
  }
}
