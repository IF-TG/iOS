//
//  FirestoreReviewWritingRepository.swift
//  travelPlan
//
//  Created by 양승현 on 4/28/24.
//

import Foundation
import Combine
import SHFirestoreService

final class FirestoreReviewWritingRepository {
  // MARK: - Dependencies
  private let service: FirestoreServiceProtocol
  private let backgroundQueue: DispatchQueue
  
  // MARK: - Properties
  private var subscriptions = Set<AnyCancellable?>()
  
  // MARK: - LifeCycle
  init(service: FirestoreServiceProtocol, backgroundQueue: DispatchQueue = .global(qos: .background)) {
    self.service = service
    self.backgroundQueue = backgroundQueue
  }
}

extension FirestoreReviewWritingRepository: ReviewWritingRepository {
  func savePost(with reviewWritingPost: ReviewWritingEntity) -> AnyPublisher<Bool, any Error> {
    return Future { [weak self, backgroundQueue] promise in
      var requestDTO = ReviewWritingSaveRequestDTO.makeRequestDTO(entity: reviewWritingPost)
      // 여기서 이미지는 따로 보내야함.
      // ReviewWritingSaveRequestDTO에서 img타입을 제너릭으로해서 Data or String이렇게 사용측에서 주입하도록 리빌딩하는것도 좋은거같다.
      
      
      let subscription = self?.service
        .request(endpoint: FirestoreReviewWritingEndpoint.savePost(with: requestDTO))
        .subscribe(on: backgroundQueue)
        .sink { completion in
          if case .failure(let error) = completion {
            promise(.failure(error))
          }
        } receiveValue: { _ in
          promise(.success(true))
        }
      self?.subscriptions.insert(subscription)
    }.eraseToAnyPublisher()
  }
  
  func updatePost(entity: ReviewWritingEntity, postId: Int64) -> AnyPublisher<Post, any Error> {
    fatalError("아직 구현하지 않았습니다.")
  }
}
