//
//  ReviewWritingRepository.swift
//  travelPlan
//
//  Created by SeokHyun on 4/9/24.
//

import Foundation
import Combine

protocol ReviewWritingRepository {
  func savePost(with reviewWritingPost: ReviewWritingEntity) -> AnyPublisher<Bool, Error>
  // Firestore의 경우 성공시 nil 반환합니다.
  func updatePost(entity: ReviewWritingEntity, postId: String) -> AnyPublisher<Post?, Error>
}
