//
//  TourIntroductionInfoFestivalResponseDTO.swift
//  travelPlan
//
//  Created by SeokHyun on 5/2/24.
//

import Foundation

// 소개정보조회 - 행사/공연/축제
struct TourIntroductionInfoFestivalResponseDTO: Decodable {
  let startDateString: String
  let endDateString: String
  let fee: String
  let ageLimit: String
  let requiredTime: String
  let content: String
  let showTime: String
  
  enum CodingKeys: String, CodingKey {
    case startDateString = "eventstartdate"
    case endDateString = "eventenddate"
    case fee = "usetimefestival"
    case ageLimit = "agelimit"
    case requiredTime = "spendtimefestival"
    case content = "program"
    case showTime = "playtime"
  }
}

extension TourIntroductionInfoFestivalResponseDTO {
  func toDomain() -> IntroductionInfoFestivalEntity {
    let startDate = DateTimeConverter.toDate(from: startDateString, dateFormat: "yyyyMMdd")
    let endDate = DateTimeConverter.toDate(from: endDateString, dateFormat: "yyyyMMdd")
    
    return .init(
      startDate: startDate,
      endDate: endDate,
      fee: fee,
      ageLimit: ageLimit,
      showTime: requiredTime,
      content: content
    )
  }
}
