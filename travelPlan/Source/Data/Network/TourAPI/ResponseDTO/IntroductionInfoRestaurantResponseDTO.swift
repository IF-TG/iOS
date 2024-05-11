//
//  IntroductionInfoRestaurantResponseDTO.swift
//  travelPlan
//
//  Created by SeokHyun on 5/10/24.
//

import Foundation

struct IntroductionInfoRestaurantResponseDTO: Decodable {
  let contentId: String
  let contentTypeId: String
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
}

// MARK: - Mappings to Domain
extension IntroductionInfoRestaurantResponseDTO {
  func toDomain() -> IntroductionInfoRestaurantEntity {
    return IntroductionInfoRestaurantEntity(
      toutContentId: .init(contentId: Int(contentId) ?? .zero,
                           contentTypeId: Int(contentTypeId) ?? .zero),
      signatureDish: signatureDish,
      menu: menu,
      telNumber: telNumber,
      canPark: canPark,
      businessHour: businessHour,
      restDay: restDay
    )
  }
}
