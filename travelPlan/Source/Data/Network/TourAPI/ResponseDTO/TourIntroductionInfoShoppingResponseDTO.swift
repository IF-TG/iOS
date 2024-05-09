//
//  TourIntroductionInfoShoppingResponseDTO.swift
//  travelPlan
//
//  Created by SeokHyun on 5/10/24.
//

import Foundation

struct TourIntroductionInfoShoppingResponseDTO: Decodable {
  let canPark: String
  let canUseCreditCard: String
  let fairDay: String
  let openTime: String
  let restDay: String
  let saleItem: String
  let telNumber: String
  
  enum CodingKeys: String, CodingKey {
    case canUseCreditCard = "chkcreditcardshopping"
    case canPark = "parkingshopping"
    case fairDay = "fairday"
    case openTime = "opentime"
    case restDay = "restdateshopping"
    case saleItem = "saleitem"
    case telNumber = "infocentershopping"
  }
}

// MARK: - Helpers
extension TourIntroductionInfoShoppingResponseDTO {
  func toDomain() -> IntroductionInfoShoppingEntity {
    return IntroductionInfoShoppingEntity(
      canPark: canPark,
      canUseCreditCard: canUseCreditCard,
      fairDay: fairDay,
      openTime: openTime,
      restDay: restDay,
      saleItem: saleItem,
      telNumber: telNumber
    )
  }
}
