//
//  ReviewWritingEndpoints.swift
//  travelPlan
//
//  Created by SeokHyun on 4/13/24.
//

import Foundation

struct ReviewWritingEndpoints {
  static func updatePost(with requestDTO: ReviewWritingUpdateRequestDTO) -> Endpoint<CommonDTO<PostResponseDTO>> {
    return .init(
      scheme: "http",
      host: "localhost:8080",
      method: .post,
      parameters: [.body(requestDTO)],
      requestType: .post(.save)
    )
  }
  
  // FIXME: - fireBase 구현에 따라 Endpoint<Void>로 만들지 말지 결정하기
  static func savePost(with requestDTO: ReviewWritingSaveRequestDTO)
  -> Endpoint<ReviewWritingSaveResponseDTO> {
    return .init(
      scheme: "http",
      host: "localhost:8080",
      method: .put,
      parameters: [.body(requestDTO)],
      requestType: .post(.save)
    )
  }
}
