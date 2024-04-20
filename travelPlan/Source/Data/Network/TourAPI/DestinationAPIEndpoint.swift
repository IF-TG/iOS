//
//  DestinationAPIEndpoint.swift
//  travelPlan
//
//  Created by 양승현 on 4/20/24.
//

import Foundation

struct DestinationAPIEndpoint {
  static func fetchDetailCommon(
    with requestDTO: TourApiDetailCommonRequestDTO
  ) -> TourApiEndpoint<TourApiCommonResponseDTO<TourApiDetailCommonResponseDTO>> {
    return .init(
      parameters: .query(requestDTO),
      requestType: .detailCommon)
  }
}
