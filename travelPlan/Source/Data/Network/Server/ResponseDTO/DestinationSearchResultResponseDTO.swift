//
//  DestinationSearchResultResponseDTO.swift
//  travelPlan
//
//  Created by SeokHyun on 7/14/24.
//

import Foundation

struct DestinationSearchResultResponseDTO: Decodable {
  let destinations: [Destination]
  let gptRelated: Bool // 이건 뭐지?
      
  struct Destination: Decodable {
    let id: Int64
    let contentTypeId: Int32
    let title: String
    let thumbnailUrl: String
    let address: String
    let category: Category
    let scraped: Bool
    
    struct Category: Decodable {
      let largeCategory: String
      let middleCategory: String
      let smallCategory: String
    }
  }
}
