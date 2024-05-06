//
//  TourImageInfoAPIEndpoint.swift
//  travelPlan
//
//  Created by 양승현 on 5/7/24.
//

import Foundation

struct TourImageInfoAPIEndpoint {
  static func makeImageInfoRetrieveEndpoint(
    with requestDTO: TourApiImageRetrieveRequestDTO
  ) -> TourApiEndpoint<TourApiCommonResponseDTO<[TourApiRetrievedImageResponseDTO]>> {
    return .init(
      parameters: .query(requestDTO),
      requestType: .detailImage)
  }
}
