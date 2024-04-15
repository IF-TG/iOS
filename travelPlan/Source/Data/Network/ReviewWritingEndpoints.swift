//
//  ReviewWritingEndpoints.swift
//  travelPlan
//
//  Created by SeokHyun on 4/13/24.
//

import Foundation

struct ReviewWritingEndpoints {
  static func savePost(with requestDTO: ReviewWritingSaveRequestDTO) -> Endpoint<CommonDTO<Bool>> {
    return .init(
      scheme: "http",
      host: "localhost:8080",
      method: .post,
      parameters: [.body(requestDTO)],
      requestType: .post(.save)
    )
  }
}
