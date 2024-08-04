//
//  DestinationAPIEndpoints.swift
//  travelPlan
//
//  Created by SeokHyun on 7/24/24.
//

import Foundation

struct DestinationAPIEndpoints {
  static func fetchDestination(with requestDTO: DestinationRequestDTO) -> Endpoint<CommonDTO<DestinationResponseDTO>> {
    return .init(
      scheme: "http",
      host: "localhost:8080",
      method: .get,
      parameters: [.query(requestDTO)],
      requestType: .destination(.detail)
    )
  }
}
