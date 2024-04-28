//
//  ShoppingResponseDTO.swift
//  travelPlan
//
//  Created by SeokHyun on 4/28/24.
//

import Foundation

struct ShoppingResponseDTO: Decodable {
  let canLoanBabyCarriage: String?
  let canAccompanyPet: String?
  let fairDate: String?
  let openDate: String?
  let openTime: String?
  let restDate: String?
  let saleItem: String?
  
  enum CodingKeys: String, CodingKey {
    case canLoanBabyCarriage = "chkbabycarriageshopping"
    case canAccompanyPet = "chkpetshopping"
    // TODO: - 영업일과 개점일의 차이점이 무엇인지 확인해봐야함
    case fairDate = "fairday" // 영업일
    case openDate = "opendateshopping" // 개점일
    case openTime = "opentime"
    case restDate = "restdateshopping"
    case saleItem = "saleitem"
  }
}
