//
//  DestinationSearchEndpoints.swift
//  travelPlan
//
//  Created by SeokHyun on 7/14/24.
//

import Foundation

struct DestinationSearchEndpoints {
  static func fetchDestinationList(
    with requestDTO: DestinationSearchRequestDTO
  ) -> Endpoint<CommonDTO<DestinationSearchResultResponseDTO>> {
    return .init(
      scheme: "http",
      host: "localhost:8080",
      method: .get,
      parameters: [.query(requestDTO)],
      requestType: .destination(.search)
    )
  }
}
