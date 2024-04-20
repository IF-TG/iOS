//
//  TourApiBaseResponseDTO.swift
//  travelPlan
//
//  Created by 양승현 on 4/20/24.
//

import Foundation

class TourApiBaseResponseDTO: Decodable {
  let resultCode: String
  let resultMsg: String
  let numOfRows: Int
  let pageNo: Int
  let totalCount: Int
}
