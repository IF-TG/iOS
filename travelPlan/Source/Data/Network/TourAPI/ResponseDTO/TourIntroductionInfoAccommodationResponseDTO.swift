//
//  TourIntroductionInfoAccommodationResponseDTO.swift
//  travelPlan
//
//  Created by SeokHyun on 5/16/24.
//

import Foundation

struct TourIntroductionInfoAccommodationResponseDTO: Decodable {
  let contentId: Int
  let contentTypeId: Int
  let checkinTime: String
  let checkoutTime: String
  let roomType: String
  let canCook: String
  let internalFacilities: String
  let telNumber: String
  let reservationNumber: String
  let canPark: String
  
  private enum CodingKeys: String, CodingKey {
    case contentId = "contentid"
    case contentTypeId = "contenttypeid"
    case checkinTime = "checkintime"
    case checkoutTime = "checkouttime"
    case roomType = "roomtype"
    case canCook = "chkcooking"
    case internalFacilities = "subfacility"
    case telNumber = "infocenterlodging"
    case reservationNumber = "reservationlodging"
    case canPark = "parkinglodging"
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
    self.checkinTime = try container.decode(String.self, forKey: .checkinTime)
    self.checkoutTime = try container.decode(String.self, forKey: .checkoutTime)
    self.roomType = try container.decode(String.self, forKey: .roomType)
    self.canCook = try container.decode(String.self, forKey: .canCook)
    self.internalFacilities = try container.decode(String.self, forKey: .internalFacilities)
    self.telNumber = try container.decode(String.self, forKey: .telNumber)
    self.reservationNumber = try container.decode(String.self, forKey: .reservationNumber)
    self.canPark = try container.decode(String.self, forKey: .canPark)
  }
}

extension TourIntroductionInfoAccommodationResponseDTO {
  func toDomain() -> IntroductionInfoAccommodationEntity {
    return IntroductionInfoAccommodationEntity(
      tourContentId: .init(contentId: contentId,
                           contentTypeId: contentTypeId),
      checkinTime: checkinTime,
      checkoutTime: checkoutTime,
      roomType: roomType,
      canCook: canCook,
      internalFacilities: internalFacilities,
      telNumber: telNumber,
      reservationNumber: reservationNumber,
      canPark: canPark
    )
  }
}
