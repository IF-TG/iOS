//
//  DestinationScrapEndpoints.swift
//  travelPlan
//
//  Created by SeokHyun on 6/30/24.
//

import Foundation

struct DestinationScrapEndpoints {
  static func toggleDestinationScrap(
    with requestDTO: DestinationScrapToggleRequestDTO
  ) -> Endpoint<CommonDTO<DestinationScrapToggleResponseDTO>> {
    return .init(
      scheme: "http",
      host: "localhost:8080",
      method: .post,
      parameters: [.body(requestDTO)],
      requestType: .destination(.toggleScrap)
    )
  }
  
  static func getDestinationScrapList(
    with requestDTO: DestinationScrapListRequestDTO
  ) -> Endpoint<CommonDTO<DestinationScrapListResponseDTO>> {
    return .init(
      scheme: "http",
      host: "localhost:8080",
      method: .get,
      parameters: [.query(requestDTO)],
      requestType: .destination(.scrapList)
    )
  }
  
  static func updateDestinationScrap(
    with requestDTO: DestinationScrapUpdateRequestDTO
  ) -> Endpoint<CommonDTO<[DestinationScrapUpdateResponseDTO]>> {
    return .init(
      scheme: "http",
      host: "localhost:8080",
      method: .put,
      parameters: [.body(requestDTO)],
      requestType: .destination(.updateScrap)
    )
  }
}
