//
//  TourAPIFestivalRequestDTO.swift
//  travelPlan
//
//  Created by SeokHyun on 4/29/24.
//

import Foundation

/// 행사정보조회
final class TourAPIFestivalRequestDTO: TourApiBaseRequestDTO {
  /// "Y": 결과리스트목록, "N": 결과리스트개수
  private let listYN = "Y"
  /// "O": 제목순, "Q": 수정일순, "R": 생성일순
  private let arrange = "O"
  /// 형식: YYYYMMDD
  private let eventStartDate: Int
  
  init(eventStartDate: Int, numOfRows: Int? = nil, pageNo: Int? = nil) {
    self.eventStartDate = eventStartDate
    super.init(numOfRows: numOfRows, pageNo: pageNo)
  }
  
  enum CodingKeys: CodingKey {
    case listYN
    case arrange
    case eventStartDate
  }
  
  override func encode(to encoder: any Encoder) throws {
    try super.encode(to: encoder)
    
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(self.listYN, forKey: .listYN)
    try container.encode(self.arrange, forKey: .arrange)
    try container.encode(self.eventStartDate, forKey: .eventStartDate)
  }
}
