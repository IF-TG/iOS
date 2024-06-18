//
//  ReviewWritingEndpoint.swift
//  travelPlan
//
//  Created by 양승현 on 4/27/24.
//

import Foundation

struct FirestoreReviewWritingEndpoint {
  static func savePost(
    with requestDTO: FirestoreReviewWritingSaveRequestDTO
  ) -> FirestoreEndpoint<ReviewWritingSaveResponseDTO> {
    return .init(
      requestDTO: requestDTO,
      method: .save(String(requestDTO.postId)),
      requestType: .posts(.save))
  }
  
  static func updatePost(
    with requestDTO: ReviewWritingUpdateRequestDTO
  ) -> FirestoreEndpoint<VoidResponseDTO> {
    return .init(
      requestDTO: requestDTO,
      method: .update,
      requestType: .posts(.update(postId: requestDTO.postId)))
  }
}
