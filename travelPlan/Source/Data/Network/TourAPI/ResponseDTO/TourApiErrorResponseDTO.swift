//
//  TourApiErrorResponseDTO.swift
//  travelPlanTests
//
//  Created by 양승현 on 4/24/24.
//

import Foundation

/// TourApi에서 받는 response에 이와 같은 형식으로 json 데이터를 전달합니다
struct TourApiErrorResponseDTO: Decodable {
  let responseTime: String
  let resultCode: String
  let resultMsg: String
}
