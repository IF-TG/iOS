//
//  RestaurantResponseDTO.swift
//  travelPlan
//
//  Created by SeokHyun on 4/28/24.
//

import Foundation

struct RestaurantResponseDTO: Decodable {
  let mainMenu: String?
  let openTime: String?
  let canPack: String?
  let parkingFacility: String?
  let restDate: String?
  let menu: String?
  
  enum CodingKeys: String, CodingKey {
    case mainMenu = "firstmenu"
    case openTime = "opentimefood"
    case canPack = "packing"
    case parkingFacility = "parkingfood"
    case restDate = "restdatefood"
    case menu = "treatmenu"
  }
}
