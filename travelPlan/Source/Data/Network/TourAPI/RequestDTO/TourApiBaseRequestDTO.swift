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
  
  init(numOfRows: Int?, pageNo: Int?, keyType: APIManager.APIKeyType) {
    self.numOfRows = numOfRows
    self.pageNo = pageNo
    let apikey = APIManager.shared.apiKey(with: keyType)
    self.serviceKey = apikey ?? ""
  }
}
