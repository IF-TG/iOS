//
//  TourAPIIntroductionEndpoints.swift
//  travelPlan
//
//  Created by SeokHyun on 5/2/24.
//

import Foundation

struct TourAPIIntroductionEndpoints {
  private init() { }
  
  static func fetchFestival(
    with requestDTO: TourIntroductionInfoRequestDTO
  ) -> TourApiEndpoint<TourApiCommonResponseDTO<TourIntroductionInfoFestivalResponseDTO>> {
    return .init(parameters: .query(requestDTO), requestType: .introduction)
  }
}
