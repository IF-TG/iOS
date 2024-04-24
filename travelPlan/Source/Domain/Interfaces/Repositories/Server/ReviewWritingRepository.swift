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
  func updatePost(entity: ReviewWritingEntity, postId: Int64) -> AnyPublisher<Post, Error>
}
