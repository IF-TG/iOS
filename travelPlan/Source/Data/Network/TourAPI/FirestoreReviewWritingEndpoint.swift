//
//  ReviewWritingEndpoint.swift
//  travelPlan
//
//  Created by 양승현 on 4/27/24.
//

import Foundation

struct FirestoreReviewWritingEndpoint {
  static func savePost(with requestDTO: ReviewWritingSaveRequestDTO)
  -> FirestoreEndpoint<ReviewWritingSaveResponseDTO> {
    return .init(
      requestDTO: requestDTO,
      method: .save,
      requestType: .posts(.save))
  }
}
