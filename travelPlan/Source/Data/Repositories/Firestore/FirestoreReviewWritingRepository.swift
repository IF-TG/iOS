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
  private let storageService = FiresabseStorageService()
  
  // MARK: - LifeCycle
  init(service: FirestoreServiceProtocol, backgroundQueue: DispatchQueue = .global(qos: .background)) {
    self.service = service
    self.backgroundQueue = backgroundQueue
  }
}

extension FirestoreReviewWritingRepository: ReviewWritingRepository {
  func savePost(with reviewWritingPost: ReviewWritingEntity) -> AnyPublisher<Bool, any Error> {
    return Future { promise in
      Task(priority: .userInitiated) { [weak self] in
        // ReviewWritingSaveRequestDTO에서 img타입을 제너릭으로해서 Data or String이렇게 사용측에서 주입하도록 리빌딩하는것도 좋은거같다.
        // 일단 구현된게 String이라 다시 Data로 변환!
        do {
          var requestDTO = ReviewWritingSaveRequestDTO.makeRequestDTO(entity: reviewWritingPost)
          guard let imagePaths = try await self?.storageService.uploadImages(
            requestDTO.imgFileList.compactMap { Data(base64Encoded: $0.img) },
            type: .postImage)
          else {
            promise(.failure(ReferenceError.invalidReference))
            return
          }
          
          (0..<imagePaths.count).forEach { i in
            requestDTO.imgFileList[i].img = imagePaths[i]
          }
          
          guard let backgroundQueue = self?.backgroundQueue else {
            promise(.failure(ReferenceError.invalidReference))
            return
          }
          
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

        } catch {
          promise(.failure(error))
        }
      }
    }.eraseToAnyPublisher()
  }
  
  func updatePost(entity: ReviewWritingEntity, postId: String) -> AnyPublisher<Post, any Error> {
    return Future { [weak self] promise in
      /// 임시로 해보자.
      let requestDTO = ReviewWritingUpdateRequestDTO(
        postId: "j5WMRcoAOoMV5xTvQgdb",
        post: ReviewWritingSaveRequestDTO.makeRequestDTO(entity: entity)
      )
      
      
    }.eraseToAnyPublisher()
  }
}
