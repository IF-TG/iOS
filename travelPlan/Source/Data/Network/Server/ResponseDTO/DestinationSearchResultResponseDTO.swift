//
//  DestinationSearchResultResponseDTO.swift
//  travelPlan
//
//  Created by SeokHyun on 7/14/24.
//

import Foundation

struct DestinationSearchResultResponseDTO: Decodable {
  let destinations: [Destination]
  let gptRelated: Bool
      
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

// MARK: - Mapping Domain
extension DestinationSearchResultResponseDTO {
  func toDomain() -> [ThumbnailDestination] {
    return destinations.map {
      .init(
        id: .init(id: $0.id, contentTypeId: $0.contentTypeId),
        title: $0.title,
        thumbnailURL: $0.thumbnailUrl,
        address: $0.address,
        category: .init(
          largeCategory: $0.category.largeCategory,
          middleCategory: $0.category.middleCategory,
          smallCategory: $0.category.smallCategory
        ),
        isScraped: $0.scraped
      )
    }
  }
}
