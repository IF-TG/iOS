//
//  TourIntroductionInfoRestaurantResponseDTO.swift
//  travelPlan
//
//  Created by SeokHyun on 5/10/24.
//

import Foundation

struct TourIntroductionInfoRestaurantResponseDTO: Decodable {
  let contentId: Int
  let contentTypeId: Int
  let signatureDish: String
  let menu: String
  let telNumber: String
  let canPark: String
  let businessHour: String
  let restDay: String
  
  private enum CodingKeys: String, CodingKey {
    case contentId = "contentid"
    case contentTypeId = "contenttypeid"
    case signatureDish = "firstmenu"
    case menu = "treatmenu"
    case telNumber = "infocenterfood"
    case canPark = "parkingfood"
    case businessHour = "opentimefood"
    case restDay = "restdatefood"
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
    self.signatureDish = try container.decode(String.self, forKey: .signatureDish)
    self.menu = try container.decode(String.self, forKey: .menu)
    self.telNumber = try container.decode(String.self, forKey: .telNumber)
    self.canPark = try container.decode(String.self, forKey: .canPark)
    self.businessHour = try container.decode(String.self, forKey: .businessHour)
    self.restDay = try container.decode(String.self, forKey: .restDay)
  }
}

// MARK: - Mappings to Domain
extension TourIntroductionInfoRestaurantResponseDTO {
  func toDomain() -> IntroductionInfoRestaurantEntity {
    return IntroductionInfoRestaurantEntity(
      toutContentId: .init(contentId: contentId,
                           contentTypeId: contentTypeId),
      signatureDish: signatureDish,
      menu: menu,
      telNumber: telNumber,
      canPark: canPark,
      businessHour: businessHour,
      restDay: restDay
    )
  }
}
