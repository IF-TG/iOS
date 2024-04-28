//
//  FestivalResponseDTO.swift
//  travelPlan
//
//  Created by SeokHyun on 4/28/24.
//

import Foundation

struct FestivalResponseDTO: Decodable {
  let ageLimit: String?
  let startDate: String?
  let endDate: String?
  let place: String?
  let content: String?
  let showTime: String?
  let fee: String?
  
  enum CodingKeys: String, CodingKey {
    case ageLimit = "agelimit"
    case startDate = "eventstartdate"
    case endDate = "eventenddate"
    case place = "eventplace"
    case content = "program"
    case showTime = "playtime"
    case fee = "usetimefestival"
  }
}
