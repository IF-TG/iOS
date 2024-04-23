//
//  ReviewWritingSaveResponseDTO.swift
//  travelPlan
//
//  Created by SeokHyun on 4/16/24.
//

import Foundation

struct ReviewWritingSaveResponseDTO: Decodable {
  let status: String
  let statusCode: String
  let message: String
}
