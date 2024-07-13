//
//  DefaultPostHeartUseCase.swift
//  travelPlan
//
//  Created by 양승현 on 7/13/24.
//

import Foundation
import Combine

final class DefaultPostHeartUseCase: PostHeartUseCase {
  // MARK: - Dependencies
  private let postRepository: PostRepository
  private var subscriptions = Set<AnyCancellable>()
  
  // MARK: - Lifecycle
  init(postRepository: PostRepository) {
    self.postRepository = postRepository
  }
  
  func heartPost(_ postId: PostIdentifier) -> AnyPublisher<Void, any Error> {
    return togglePost(
      postId: postId,
      initialResult: { $0 },
      retryResult: { !$0 })
  }
  
  func hatePost(_ postId: PostIdentifier) -> AnyPublisher<Void, any Error> {
    return togglePost(
      postId: postId,
      initialResult: { !$0 },
      retryResult: { $0 })
  }
  
}

// MARK: - Private Helpers
private extension DefaultPostHeartUseCase {
  func makeToggleError() -> any Error {
    let errDomain = "com.yeogaApp.PostHeartError"
    let errorCode = 1001
    let errorUserInfo: [String: Any] = [
      NSLocalizedDescriptionKey: "서버가 불안정해 포스트 하트 처리 반영이 안됩니다. 나중에 다시 시도해주세요."
    ]
    return NSError(domain: errDomain, code: errorCode, userInfo: errorUserInfo)
  }
  
  /// initialResult에 따라서 retry할지 안할지를 결정합니다.
  /// heartPost는 initialRes에 true가 담겨야하지만, hatePost에는 initialRes에 false가 담겨야합니다.
  ///   heartPost를 예로 들자면 그 이후의 retry에선 여전히 좋아요를 해야하지만 싫어요 false가 서버에서 올 경우 나올 경우 에러를 던집니다.
  func togglePost(
    postId: PostIdentifier,
    initialResult: @escaping (Bool) -> Bool,
    retryResult: @escaping (Bool) -> Bool
  ) -> AnyPublisher<Void, any Error> {
    return postRepository
      .togglePostHeart(postId: postId)
      .flatMap { [weak self] res -> AnyPublisher<Void, any Error> in
        guard let self else {
          return Fail(error: ReferenceError.invalidReference).eraseToAnyPublisher()
        }
        if initialResult(res) {
          return Just(()).setAnyErrorAndEraseToAnyPublisher()
        }
        // 좋아요를 했으나, 좋아요가 아닌 싫어요가 된 경우
        return self.postRepository.togglePostHeart(postId: postId)
          .tryMap { [weak self] retryRes -> Void in
            guard let self else { throw ReferenceError.invalidReference }
            
            if retryResult(retryRes) {
              throw makeToggleError()
            }
            
            return ()
          }.eraseToAnyPublisher()
      }.eraseToAnyPublisher()
  }
}
