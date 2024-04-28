//
//  TouristAttractionResponseDTO.swift
//  travelPlan
//
//  Created by SeokHyun on 4/28/24.
//

import Foundation

struct TouristAttractionResponseDTO: Decodable {
  let canLoanBabyCarriage: String?
  let canAccompanyPet: String?
  let experienceGuide: String?
  let openDate: String?
  let restDate: String?
  let availableTime: String?
  
  enum CodingKeys: String, CodingKey {
    case canLoanBabyCarriage = "chkbabycarriage"
    case canAccompanyPet = "chkpet"
    case experienceGuide = "expguide"
    case openDate = "opendate"
    case restDate = "restdate"
    case availableTime = "usetime"
  }
}
