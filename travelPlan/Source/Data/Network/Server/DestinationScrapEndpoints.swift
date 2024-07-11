//
//  DestinationScrapEndpoints.swift
//  travelPlan
//
//  Created by SeokHyun on 6/30/24.
//

import Foundation

struct DestinationScrapEndpoints {
//  static func getAllDestinationScrapsByScrapFolderAndUserId(
//    with requestDTO: RequestDTO1
//  ) -> Endpoint<CommonDTO<ResopnseDTO>> {
//    
//  }
  
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
  
  static func updateDestinationScrap(
    with requestDTO: RequestDTO3
  ) -> Endpoint<CommonDTO<ResponseDTO2>> {
    
  }
}
