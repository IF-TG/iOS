//
//  TourApiImageRetrieveRequestDTO.swift
//  travelPlan
//
//  Created by 양승현 on 5/7/24.
//

import Foundation

final class TourApiImageRetrieveRequestDTO: TourApiBaseRequestDTO {
  let contentId: Int
  let imageYN: String = "Y"
  let subImageYN: String = "Y"
  
  init(
    contentId: Int,
    numOfRows: Int?,
    pageNo: Int?
  ) {
    self.contentId = contentId
    super.init(numOfRows: numOfRows, pageNo: pageNo)
  }
  
  enum CodingKeys: CodingKey {
    case contentId
    case imageYN
    case subImageYN
  }
  
  override func encode(to encoder: any Encoder) throws {
    try super.encode(to: encoder)
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(self.contentId, forKey: .contentId)
    try container.encode(self.imageYN, forKey: .imageYN)
    try container.encode(self.subImageYN, forKey: .subImageYN)
  }
}
