//
//  ReviewWritingUseCase.swift
//  travelPlan
//
//  Created by SeokHyun on 4/9/24.
//

import Foundation
import Combine
import Photos

protocol ReviewWritingUseCase {
  func savePost(entity: ReviewWritingEntity) -> AnyPublisher<Bool, any Error>
  func updatePost(requestValue: ReviewWritingUseCaseUpdateRequestValue) -> AnyPublisher<Post?, any Error>
  func requestAuthorization() -> AnyPublisher<PHAuthorizationStatus, Never>
}
