//
//  DestinationLikeEndpoints.swift
//  travelPlan
//
//  Created by SeokHyun on 7/24/24.
//

import Foundation

struct DestinationLikeEndpoints {
  static func toggleLikeDestination(
    with requestDTO: DestinationLikeRequestDTO
  ) -> Endpoint<CommonDTO<DestinationLikeResponseDTO>> {
    return .init(
      scheme: "http",
      host: "localhost:8080",
      method: .post,
      parameters: [.body(requestDTO)],
      requestType: .destination(.like)
    )
  }
}
