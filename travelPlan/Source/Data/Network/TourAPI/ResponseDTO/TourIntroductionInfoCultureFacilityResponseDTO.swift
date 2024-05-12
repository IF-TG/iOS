//
//  TourIntroductionInfoCultureFacilityResponseDTO.swift
//  travelPlan
//
//  Created by SeokHyun on 5/12/24.
//

import Foundation

struct TourIntroductionInfoCultureFacilityResponseDTO: Decodable {
  let contentId: Int
  let contentTypeId: Int
  let telNumber: String
  let availableTime: String
  let canPark: String
  let canAccompanyDog: String
  let restDay: String
  
  private enum CodingKeys: String, CodingKey {
    case contentId = "contentid"
    case contentTypeId = "contenttypeid"
    case telNumber = "infocenterculture"
    case availableTime = "usetimeculture"
    case canPark = "parkingculture"
    case canAccompanyDog = "chkpetculture"
    case restDay = "restdateculture"
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
    self.availableTime = try container.decode(String.self, forKey: .availableTime)
    self.canPark = try container.decode(String.self, forKey: .canPark)
    self.canAccompanyDog = try container.decode(String.self, forKey: .canAccompanyDog)
    self.restDay = try container.decode(String.self, forKey: .restDay)
  }
}

extension TourIntroductionInfoCultureFacilityResponseDTO {
  func toDomain() -> IntroductionInfoCultureFacilityEntity {
    return .init(
      tourContentId: .init(contentId: contentId, contentTypeId: contentTypeId),
      telNumber: telNumber,
      availableTime: availableTime,
      canPark: canPark,
      canAccompanyDog: canAccompanyDog,
      restDay: restDay
    )
  }
}
