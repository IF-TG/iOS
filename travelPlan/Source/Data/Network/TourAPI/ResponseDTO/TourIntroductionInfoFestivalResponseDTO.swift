//
//  TourIntroductionInfoFestivalResponseDTO.swift
//  travelPlan
//
//  Created by SeokHyun on 5/2/24.
//

import Foundation

// 소개정보조회 - 행사/공연/축제
struct TourIntroductionInfoFestivalResponseDTO: Decodable {
  let startDate: String
  let endDate: String
  let fee: String
  let ageLimit: String
  let requiredTime: String
  let content: String
  let showTime: String
  
  enum CodingKeys: String, CodingKey {
    case startDate = "eventstartdate"
    case endDate = "eventenddate"
    case fee = "usetimefestival"
    case ageLimit = "agelimit"
    case requiredTime = "spendtimefestival"
    case content = "program"
    case showTime = "playtime"
  }
}

extension TourIntroductionInfoFestivalResponseDTO {
  func toDomain() -> IntroductionInfoFestivalEntity {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyyMMdd"
    dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
    return .init(
      startDate: dateFormatter.date(from: startDate),
      endDate: dateFormatter.date(from: endDate),
      fee: fee,
      ageLimit: ageLimit,
      showTime: requiredTime,
      content: content
    )
  }
}
