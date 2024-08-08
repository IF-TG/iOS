//
//  DestinationRecommendAPIEndpoints.swift
//  travelPlan
//
//  Created by SeokHyun on 8/8/24.
//

import Foundation

struct DestinationRecommendAPIEndpoints {
  static func fetchRecommendList(
    with requestDTO: PagingRequestDTO
  ) -> Endpoint<CommonDTO<[DestinationRecommendResponseDTO]>> {
    return .init(
      scheme: "http",
      host: "localhost:8080",
      method: .get,
      parameters: [.query(requestDTO)],
      requestType: .destination(.recommend)
    )
  }
}
