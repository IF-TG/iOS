//
//  TourApiDetailCommonRequestDTO.swift
//  travelPlan
//
//  Created by 양승현 on 4/20/24.
//

import Foundation

/// 이를 활용하면 다음과 같은 정보를 얻을 수 있습니다.
/// contentId에 따른 주소, 좌표, 컨텐츠 소개 글, 컨텐츠 관광지 관련 연락 주소 명, 번호
final class TourApiDetailCommonRequestDTO: TourApiBaseRequestDTO {
  let contentId: Int
  let addrinfoYN = "Y"
  let mapinfoYN = "Y"
  let overviewYN = "Y"
  let defaultYN = "Y"
  
  /// 여기선 사실상 contentId에 따라서 특정한 한 데이터만 받아올 것으로 예상되어 페이징이 의미 없습니다.
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
    case addrinfoYN
    case mapinfoYN
    case overviewYN
    case defaultYN
  }
  
  override func encode(to encoder: any Encoder) throws {
    try super.encode(to: encoder)
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(self.contentId, forKey: .contentId)
    try container.encode(self.addrinfoYN, forKey: .addrinfoYN)
    try container.encode(self.mapinfoYN, forKey: .mapinfoYN)
    try container.encode(self.overviewYN, forKey: .overviewYN)
    try container.encode(self.defaultYN, forKey: .defaultYN)
    
  }
}
