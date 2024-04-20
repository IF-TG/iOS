//
//  TourApiBaseRequestDTO.swift
//  travelPlan
//
//  Created by 양승현 on 4/20/24.
//

import Foundation

/// Tour API를 활용한다면 base request DTO를 상속 받아야 합니다.
class TourApiBaseRequestDTO: Encodable {
  let numOfRows: Int?
  let pageNo: Int?
  let MobileOS: String = "IOS"
  let MobileApp: String = "YeoGa"
  let serviceKey: String
  let _type: String = "json"
  
  init(numOfRows: Int?, pageNo: Int?) {
    self.numOfRows = numOfRows
    self.pageNo = pageNo
    let apikey = APIManager.shared.apiKey(with: .tourAPI)
    self.serviceKey = apikey ?? ""
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(numOfRows, forKey: .numOfRows)
    try container.encode(pageNo, forKey: .pageNo)
    try container.encode(MobileOS, forKey: .MobileOS)
    try container.encode(MobileApp, forKey: .MobileApp)
    try container.encode(serviceKey, forKey: .serviceKey)
    try container.encode(_type, forKey: ._type)
  }
  
  private enum CodingKeys: String, CodingKey {
    case numOfRows
    case pageNo
    case MobileOS
    case MobileApp
    case serviceKey
    case _type
  }
}
