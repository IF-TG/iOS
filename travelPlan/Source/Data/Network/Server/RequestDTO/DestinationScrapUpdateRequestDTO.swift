//
//  DestinationScrapUpdateRequestDTO.swift
//  travelPlan
//
//  Created by SeokHyun on 7/12/24.
//

import Foundation

struct DestinationScrapUpdateRequestDTO: Encodable {
  let objectIdList: [Int64]
  let forderName: String
}
