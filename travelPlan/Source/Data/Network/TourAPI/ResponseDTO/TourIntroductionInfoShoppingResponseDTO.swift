//
//  TourIntroductionInfoShoppingResponseDTO.swift
//  travelPlan
//
//  Created by SeokHyun on 5/10/24.
//

import Foundation

struct TourIntroductionInfoShoppingResponseDTO: Decodable {
  let contentId: Int
  let contentTypeId: Int
  let canPark: String
  let fairDay: String
  let openTime: String
  let restDay: String
  let saleItem: String
  let telNumber: String
  
  enum CodingKeys: String, CodingKey {
    case contentId = "contentid"
    case contentTypeId = "contenttypeid"
    case canPark = "parkingshopping"
    case fairDay = "fairday"
    case openTime = "opentime"
    case restDay = "restdateshopping"
    case saleItem = "saleitem"
    case telNumber = "infocentershopping"
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
    self.canPark = try container.decode(String.self, forKey: .canPark)
    self.fairDay = try container.decode(String.self, forKey: .fairDay)
    self.openTime = try container.decode(String.self, forKey: .openTime)
    self.restDay = try container.decode(String.self, forKey: .restDay)
    self.saleItem = try container.decode(String.self, forKey: .saleItem)
    self.telNumber = try container.decode(String.self, forKey: .telNumber)
  }
}

// MARK: - Helpers
extension TourIntroductionInfoShoppingResponseDTO {
  func toDomain() -> IntroductionInfoShoppingEntity {
    return IntroductionInfoShoppingEntity(
      tourContentId: .init(contentId: contentId,
                           contentTypeId: contentTypeId),
      canPark: canPark,
      fairDay: fairDay,
      openTime: openTime,
      restDay: restDay,
      saleItem: saleItem,
      telNumber: telNumber
    )
  }
}
