//
//  DestinationCategoryResponseDTO.swift
//  travelPlan
//
//  Created by SeokHyun on 8/8/24.
//

import Foundation

struct DestinationCategoryResponseDTO: Decodable {
  let large: String
  let middle: String
  let small: String
  
  enum CodingKeys: String, CodingKey {
    case large = "largeCategory"
    case middle = "middleCategory"
    case small = "smallCategory"
  }
}
