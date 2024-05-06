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
  
  /// 저작권?!
  let cpyrhtDivCd: String
  let serialNumber: String
  
  enum CodingKeys: String, CodingKey {
    case contentId
    case originimgurl
    case smallimageurl
    case cpyrhtDivCd
    case serialNumber = "serialnum"
  }
  
  init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    contentId = try container.decode(String.self, forKey: .contentId)
    cpyrhtDivCd = try container.decode(String.self, forKey: .cpyrhtDivCd)
    serialNumber = try container.decode(String.self, forKey: .serialNumber)
    image = try Image(from: decoder)
  }
  
  struct Image: Decodable {
    let originalUrl: String
    let thumbnailUrl: String
    
    enum CodingKeys: String, CodingKey {
      case originalUrl = "originimgurl"
      case thumbnailUrl = "smallimageurl"
    }
  }
}
