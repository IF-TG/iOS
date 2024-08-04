//
//  DestinationScrapDetailResponseDTO.swift
//  travelPlan
//
//  Created by SeokHyun on 7/12/24.
//

import Foundation

struct DestinationScrapDetailResponseDTO: Decodable {
  let id: Int
  let contentTypeId: Int
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
extension DestinationScrapDetailResponseDTO {
  func toDomain() -> DestinationScrapDetail {
    return .init(
      id: .init(id: id, contentTypeId: contentTypeId),
      title: title,
      address: .init(address1: address, address2: addressDetail),
      map: .init(mapX: mapX, mapY: mapY),
      overview: overview,
      tel: tel,
      category: .init(large: category.largeCategory,
                      middle: category.middleCategory,
                      small: category.smallCategory),
      thumbnailImageData: Data(base64Encoded: thumbnail),
      isScraped: scraped
    )
  }
}

