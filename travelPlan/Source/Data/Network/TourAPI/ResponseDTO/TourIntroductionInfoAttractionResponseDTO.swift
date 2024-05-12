//
//  TourIntroductionInfoAttractionResponseDTO.swift
//  travelPlan
//
//  Created by SeokHyun on 5/12/24.
//

import Foundation

struct TourIntroductionInfoAttractionResponseDTO: Decodable {
  let contentId: Int
  let contentTypeId: Int
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
  
  init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let contentIdString = try container.decode(String.self, forKey: .contentId)
    let contentTypeIdString = try container.decode(String.self, forKey: .contentTypeId)
    
    guard
      let contentId = Int(contentIdString),
      let contentTypeId = Int(contentTypeIdString)
    else { throw TransformationError.stringToInt }
    
    self.contentId = contentId
    self.contentTypeId = contentTypeId
    self.telNumber = try container.decode(String.self, forKey: .telNumber)
    self.restDateString = try container.decode(String.self, forKey: .restDateString)
    self.availableTime = try container.decode(String.self, forKey: .availableTime)
    self.canPark = try container.decode(String.self, forKey: .canPark)
    self.canAccompanyDog = try container.decode(String.self, forKey: .canAccompanyDog)
    self.experienceInfo = try container.decode(String.self, forKey: .experienceInfo)
  }
}

// MARK: - Mappings to Domain
extension TourIntroductionInfoAttractionResponseDTO {
  func toDomain() -> IntroductionInfoAttractionEntity {
    return IntroductionInfoAttractionEntity(
      tourContentId: .init(contentId: contentId,
                           contentTypeId: contentTypeId),
      restDateString: restDateString,
      telNumber: telNumber,
      availableTime: availableTime,
      canPark: canPark,
      canAccompanyDog: canAccompanyDog,
      experienceInfo: experienceInfo
    )
  }
}
