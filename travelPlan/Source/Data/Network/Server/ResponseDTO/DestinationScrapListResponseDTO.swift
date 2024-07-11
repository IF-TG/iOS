//
//  DestinationScrapListResponseDTO.swift
//  travelPlan
//
//  Created by SeokHyun on 7/12/24.
//

import Foundation

struct DestinationScrapListResponseDTO: Decodable {
  let id: Int64
  let contentTypeId: Int32
  let title: String
  let address: String
  let addressDetail: String
  let mapX: Double
  let mapY: Double
  let overview: String
  let tel: String
  let category: Category
  let zipcode: String
  let thumbnail: String
  let scraped: Bool
  
  struct Category: Decodable {
    let largeCategory: String
    let middleCategory: String
    let smallCategory: String
  }
}

// MARK: - Mapping Domain
extension DestinationScrapListResponseDTO {
  func toDomain() -> DestinationScrapList {
    
  }
}
