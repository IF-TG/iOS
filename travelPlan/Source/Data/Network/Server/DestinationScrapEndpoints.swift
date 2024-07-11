//
//  DestinationScrapEndpoints.swift
//  travelPlan
//
//  Created by SeokHyun on 6/30/24.
//

import Foundation

struct DestinationScrapEndpoints {
  static func toggleDestinationScrap(
    with requestDTO: DestinationScrapRequestDTO
  ) -> Endpoint<CommonDTO<DestinationScrapResponseDTO>> {
    return .init(
      scheme: "http",
      host: "localhost:8080",
      method: .post,
      parameters: [.body(requestDTO)],
      requestType: .destination(.toggleScrap)
    )
  }
}
