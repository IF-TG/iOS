//
//  CultureFacilityResponseDTO.swift
//  travelPlan
//
//  Created by SeokHyun on 4/28/24.
//

import Foundation

struct CultureFacilityResponseDTO: Decodable {
  let canLoanBabyCarriage: String?
  let canAccompanyPet: String?
  let parkingFacility: String?
  let parkingFee: String?
  let useFee: String?
  let availableTime: String?
  
  enum CodingKeys: String, CodingKey {
    case canLoanBabyCarriage = "chkbabycarriageculture"
    case canAccompanyPet = "chkpetculture"
    case parkingFacility = "parkingculture"
    case parkingFee = "parkingfee"
    case useFee = "usefee"
    case availableTime = "usetimeculture"
  }
}
