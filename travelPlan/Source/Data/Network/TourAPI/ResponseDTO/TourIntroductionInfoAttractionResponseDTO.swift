//
//  TourIntroductionInfoAttractionResponseDTO.swift
//  travelPlan
//
//  Created by SeokHyun on 5/12/24.
//

import Foundation

struct TourIntroductionInfoAttractionResponseDTO: Decodable {
  let contentId: String
  let contentTypeId: String
  let telNumber: String
  let restDateString: String
  let availableTime: String
  let canPark: String
  let canAccompanyDog: String
  let experienceInfo: String
  
  private enum CodingKeys: String, CodingKey {
    case contentId = "contentid"
    case contentTypeId = "contenttypeid"
    case telNumber = "infocenter"
    case restDateString = "restdate"
    case availableTime = "usetime"
    case canPark = "parking"
    case canAccompanyDog = "chkpet"
    case experienceInfo = "expguide"
  }
}

// MARK: - Mappings to Domain
extension TourIntroductionInfoAttractionResponseDTO {
  func toDomain() -> IntroductionInfoAttractionEntity {
    return IntroductionInfoAttractionEntity(
      tourContentId: .init(contentId: Int(contentId) ?? .zero, 
                           contentTypeId: Int(contentTypeId) ?? .zero),
      restDateString: restDateString,
      telNumber: telNumber,
      availableTime: availableTime,
      canPark: canPark,
      canAccompanyDog: canAccompanyDog,
      experienceInfo: experienceInfo
    )
  }
}
