//
//  TourIntroductionInfoFestivalResponseDTO.swift
//  travelPlan
//
//  Created by SeokHyun on 5/2/24.
//

import Foundation

// 소개정보조회 - 행사/공연/축제
struct TourIntroductionInfoFestivalResponseDTO: Decodable {
  let contentId: Int
  let contentTypeId: Int
  let startDateString: String
  let endDateString: String
  let fee: String
  let ageLimit: String
  let content: String
  let showTime: String
  
  enum CodingKeys: String, CodingKey {
    case contentId = "contentid"
    case contentTypeId = "contenttypeid"
    case startDateString = "eventstartdate"
    case endDateString = "eventenddate"
    case fee = "usetimefestival"
    case ageLimit = "agelimit"
    case content = "program"
    case showTime = "playtime"
  }
  
  init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    let contentIdString = try container.decode(String.self, forKey: .contentId)
    let contentTypeIdString = try container.decode(String.self, forKey: .contentTypeId)
    
    guard let contentId = Int(contentIdString),
          let contentTypeId = Int(contentTypeIdString)
    else { throw TransformationError.stringToInt }
    
    self.contentId = contentId
    self.contentTypeId = contentTypeId
    self.startDateString = try container.decode(String.self, forKey: .startDateString)
    self.endDateString = try container.decode(String.self, forKey: .endDateString)
    self.fee = try container.decode(String.self, forKey: .fee)
    self.ageLimit = try container.decode(String.self, forKey: .ageLimit)
    self.content = try container.decode(String.self, forKey: .content)
    self.showTime = try container.decode(String.self, forKey: .showTime)
  }
}

extension TourIntroductionInfoFestivalResponseDTO {
  func toDomain() -> IntroductionInfoFestivalEntity {
    let startDate = DateTimeConverter.toDate(from: startDateString, dateFormat: "yyyyMMdd")
    let endDate = DateTimeConverter.toDate(from: endDateString, dateFormat: "yyyyMMdd")
    
    return IntroductionInfoFestivalEntity(
      tourContentId: .init(contentId: contentId,
                           contentTypeId: contentTypeId),
      startDate: startDate,
      endDate: endDate,
      fee: fee,
      ageLimit: ageLimit,
      showTime: showTime,
      content: content
    )
  }
}
