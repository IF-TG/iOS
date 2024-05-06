//
//  TourApiRetrievedImageResponseDTO.swift
//  travelPlan
//
//  Created by 양승현 on 5/7/24.
//

import Foundation

struct TourApiRetrievedImageResponseDTO: Decodable {
  let contentId: String
  let image: Image
  let copyright: ImageCopyright
  
  enum CodingKeys: String, CodingKey {
    case contentId
  }
  
  init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    contentId = try container.decode(String.self, forKey: .contentId)
    image = try Image(from: decoder)
    copyright = try ImageCopyright(from: decoder)
  }
  
  struct Image: Decodable {
    let name: String
    let originalUrl: String
    let thumbnailUrl: String
    
    enum CodingKeys: String, CodingKey {
      case originalUrl = "originimgurl"
      case thumbnailUrl = "smallimageurl"
      case name = "imgname"
    }
    
    func toDomain() -> TourRetrievedAtomicImageEntity {
      return .init(
        name: name,
        originalUrl: originalUrl,
        thumbnailUrl: thumbnailUrl)
    }
  }
  
  struct ImageCopyright: Decodable {
    let divisionCode: String
    let serialNumber: String
    
    enum CodingKeys: String, CodingKey {
      case divisionCode = "cpyrhtDivCd"
      case serialNumber = "serialnum"
    }
    
    func toDomain() -> TourRetrievedImageCopyrightEntity {
      return .init(
        divisionCode: divisionCode, 
        serialNumber: serialNumber)
    }
  }
}

// MARK: - Mappings doamin
extension TourApiRetrievedImageResponseDTO {
  func toDomain() -> TourRetrievedImageEntity<TourRetrievedAtomicImageEntity> {
    return .init(
      contentId: contentId,
      image: image.toDomain(),
      copyright: copyright.toDomain())
  }
}
