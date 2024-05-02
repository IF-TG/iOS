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
  let place: String
  let ageLimit: String
  let requiredTime: String
  
  enum CodingKeys: String, CodingKey {
    case startDate = "eventstartdate"
    case endDate = "eventenddate"
    case fee = "usetimefestival"
    case place = "eventplace"
    case ageLimit = "agelimit"
    case requiredTime = "spendtimefestival"
  }
}

extension TourIntroductionInfoFestivalResponseDTO {
  func toDomain() -> IntroductionInfoFestivalEntity {
    return .init(
      startDate: startDate,
      endDate: endDate,
      fee: fee,
      place: place,
      ageLimit: ageLimit,
      showTime: requiredTime
    )
  }
}
