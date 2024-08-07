//
//  DestinationRecommendResponseDTO.swift
//  travelPlan
//
//  Created by SeokHyun on 8/8/24.
//

import Foundation

struct DestinationRecommendResponseDTO: Decodable {
  let sections: [Section]
  
  struct Section: Decodable {
    let title: String
    let destinations: [Destination]
    
    struct Destination: Decodable {
      let destinationId: DestinationIdResponseDTO
      let title: String
      let thumbnailUrl: String
      let category: DestinationCategoryResponseDTO
      let address: String
      let scraped: Bool
    }
  }
}

// MARK: - Mapping to Domain
extension DestinationRecommendResponseDTO {
  func toDomain() -> [DestinationRecommendSection] {
    let sections = sections.map {
      let destinations = $0.destinations.map {
        return DestinationRecommendSection.Destination(
          destinationId: DestinationIdEntity(
            id: $0.destinationId.id,
            contentTypeId: $0.destinationId.contentTypeId
          ),
          title: $0.title,
          thumbnailData: Data(base64Encoded: $0.thumbnailUrl),
          address: $0.address,
          category: DestinationCategory(
            large: $0.category.large,
            middle: $0.category.middle,
            small: $0.category.small
          ),
          isScaped: $0.scraped
        )
      }
      
      return sections
    }
  }
}
