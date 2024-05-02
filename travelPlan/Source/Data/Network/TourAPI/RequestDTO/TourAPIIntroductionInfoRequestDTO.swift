//
//  TourAPIIntroductionInfoRequestDTO.swift
//  travelPlan
//
//  Created by SeokHyun on 5/2/24.
//

import Foundation

/// 소개정보조회
final class TourAPIIntroductionInfoRequestDTO: TourApiBaseRequestDTO {
  let contentId: Int
  let contentTypeId: Int
  
  init(contentId: Int, contentTypeId: Int) {
    self.contentId = contentId
    self.contentTypeId = contentTypeId
    
    super.init(numOfRows: nil, pageNo: nil)
  }
  
  enum CodingKeys: CodingKey {
    case contentId
    case contentTypeId
  }
  
  override func encode(to encoder: any Encoder) throws {
    try super.encode(to: encoder)
    
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(self.contentId, forKey: .contentId)
    try container.encode(self.contentTypeId, forKey: .contentTypeId)
  }
}
