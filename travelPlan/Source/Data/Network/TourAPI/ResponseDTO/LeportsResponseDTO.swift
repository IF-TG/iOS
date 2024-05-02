//
//  LeportsResponseDTO.swift
//  travelPlan
//
//  Created by SeokHyun on 4/28/24.
//

import Foundation

struct LeportsResponseDTO: Decodable {
  let canLoanBabyCarriage: String
  let canAccompanyPet: String
  let openPeriod: String
  let parkingFacility: String
  let parkingFee: String
  let ageLimit: String
  let fee: String
  let availableTime: String
  
  enum CodingKeys: String, CodingKey {
    case canLoanBabyCarriage = "chkbabycarriageleports"
    case canAccompanyPet = "chkpetleports"
    case openPeriod = "openperiod"
    case parkingFacility = "parkingleports"
    case parkingFee = "parkingfeeleports"
    case ageLimit = "expagerangeleports"
    case fee = "usefeeleports"
    case availableTime = "usetimeleports"
  }
}
