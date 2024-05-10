//
//  TourAPIFestivalEndpoints.swift
//  travelPlan
//
//  Created by SeokHyun on 5/2/24.
//

import Foundation

struct TourAPIFestivalEndpoints {
  private init() { }
  
  static func fetchFestivalList(
    with requestDTO: TourAPIFestivalRequestDTO
  ) -> TourApiEndpoint<TourApiCommonResponseDTO<TourFestivalResponseDTO>> {
    return .init(parameters: .query(requestDTO), requestType: .festival)
  }
}
