//
//  TourIntroductionInfoLeportsResponseDTO.swift
//  travelPlan
//
//  Created by SeokHyun on 5/12/24.
//

import Foundation

struct TourIntroductionInfoLeportsResponseDTO: Decodable {
  let contentId: Int
  let contentTypeId: Int
  let operationPeriod: String
  let telNumber: String
  let restDay: String
  let availableTime: String
  let canPark: String
  let canAccompanyDog: String
  let fee: String
  
  private enum CodingKeys: String, CodingKey {
    case contentId = "contentid"
    case contentTypeId = "contenttypeid"
    case operationPeriod = "openperiod"
    case telNumber = "infocenterleports"
    case restDay = "restdateleports"
    case availableTime = "usetimeleports"
    case canPark = "parkingleports"
    case canAccompanyDog = "chkpetleports"
    case fee = "usefeeleports"
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
    self.operationPeriod = try container.decode(String.self, forKey: .operationPeriod)
    self.telNumber = try container.decode(String.self, forKey: .telNumber)
    self.restDay = try container.decode(String.self, forKey: .restDay)
    self.availableTime = try container.decode(String.self, forKey: .availableTime)
    self.canPark = try container.decode(String.self, forKey: .canPark)
    self.canAccompanyDog = try container.decode(String.self, forKey: .canAccompanyDog)
    self.fee = try container.decode(String.self, forKey: .fee)
  }
}

// MARK: - Mappings to Domain
extension TourIntroductionInfoLeportsResponseDTO {
  func toDomain() -> IntroductionInfoLeportsEntity {
    return .init(
      tourContentId: .init(contentId: contentId, contentTypeId: contentTypeId),
      operationPeriod: operationPeriod,
      telNumber: telNumber,
      restDay: restDay,
      availableTime: availableTime,
      canPark: canPark,
      canAccompanyDog: canAccompanyDog,
      fee: fee
    )
  }
}
