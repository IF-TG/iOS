//
//  TourIntroductionInfoShoppingResponseDTO.swift
//  travelPlan
//
//  Created by SeokHyun on 5/10/24.
//

import Foundation

struct TourIntroductionInfoShoppingResponseDTO: Decodable {
  let canLoanBabyCarriage: String
  let canAccompanyPet: String
  let fairDateString: String
  let openDateString: String
  let openTime: String
  let restDateString: String
  let saleItem: String
  
  enum CodingKeys: String, CodingKey {
    case canLoanBabyCarriage = "chkbabycarriageshopping"
    case canAccompanyPet = "chkpetshopping"
    case fairDateString = "fairday"
    case openDateString = "opendateshopping"
    case openTime = "opentime"
    case restDateString = "restdateshopping"
    case saleItem = "saleitem"
  }
}

// MARK: - Helpers
extension TourIntroductionInfoShoppingResponseDTO {
  func toDomain() -> ShoppingEntity {
    let fairDate = stringToDate(from: fairDateString)
    let openDate = stringToDate(from: openDateString)
    let restDate = stringToDate(from: restDateString)
    
    return ShoppingEntity(
      canLoanBabyCarriage: canLoanBabyCarriage,
      canAccompanyPet: canAccompanyPet,
      fairDate: fairDate,
      openDate: openDate,
      openTime: openTime,
      restDate: restDate,
      saleItem: saleItem
    )
  }
}

// MARK: - Private Helpers
extension TourIntroductionInfoShoppingResponseDTO {
  private func stringToDate(from dateString: String) -> Date? {
    DateTimeConverter.toDate(from: dateString, dateFormat: "yyyyMMdd")
  }
}
