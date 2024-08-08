//
//  DestinationRecommendResponseDTO.swift
//  travelPlan
//
//  Created by SeokHyun on 8/8/24.
//

import Foundation

struct DestinationRecommendResponseDTO: Decodable {
  let title: String
  let destinations: [Destination]
  
  enum CodingKeys: String, CodingKey {
    case title
    case destinations = "destination"
  }
  
  struct Destination: Decodable {
    let id: Int
    let contentTypeId: Int
    let title: String
    let thumbnailUrl: String
    let largeCategory: String
    let smallCategory: String
    let middleCategory: String
    let address: String
    let scraped: Bool
  }
}

// MARK: - Mapping to Domain
extension DestinationRecommendResponseDTO {
  func toDomain() -> DestinationRecommendSection {
    let destinations = destinations.map { destination -> DestinationRecommendSection.Destination in
      
      return DestinationRecommendSection.Destination(
        destinationId: DestinationIdEntity(
          id: destination.id,
          contentTypeId: destination.contentTypeId
        ),
        title: destination.title,
        thumbnailData: Data(base64Encoded: destination.thumbnailUrl),
        address: destination.address,
        category: DestinationCategory(
          large: destination.largeCategory,
          middle: destination.middleCategory,
          small: destination.smallCategory
        ),
        isScaped: destination.scraped
      )
    }
    
    return DestinationRecommendSection(
      title: title,
      destinations: destinations
    )
  }
}
