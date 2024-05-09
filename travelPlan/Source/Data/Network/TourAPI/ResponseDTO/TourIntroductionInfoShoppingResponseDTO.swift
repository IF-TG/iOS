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
  let fairDateString: String
  let openTime: String
  let restDateString: String
  let saleItem: String
  let telNumber: String
  
  enum CodingKeys: String, CodingKey {
    case canUseCreditCard = "chkcreditcardshopping"
    case canPark = "parkingshopping"
    case fairDateString = "fairday"
    case openTime = "opentime"
    case restDateString = "restdateshopping"
    case saleItem = "saleitem"
    case telNumber = "infocentershopping"
  }
}

// MARK: - Helpers
extension TourIntroductionInfoShoppingResponseDTO {
  func toDomain() -> IntroductionInfoShoppingEntity {
    let fairDate = stringToDate(from: fairDateString)
    let restDate = stringToDate(from: restDateString)
    
    
  }
}

// MARK: - Private Helpers
extension TourIntroductionInfoShoppingResponseDTO {
  private func stringToDate(from dateString: String) -> Date? {
    DateTimeConverter.toDate(from: dateString, dateFormat: "yyyyMMdd")
  }
}
