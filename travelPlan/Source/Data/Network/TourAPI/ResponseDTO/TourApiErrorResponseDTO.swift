//
//  TourApiErrorResponseDTO.swift
//  travelPlanTests
//
//  Created by 양승현 on 4/24/24.
//

import Foundation

struct TourApiErrorResponseDTO: Decodable {
  let responseTime: String
  let resultCode: String
  let resultMsg: String
}
