//
//  DestinationScrapListRequestDTO.swift
//  travelPlan
//
//  Created by SeokHyun on 7/12/24.
//

import Foundation

struct DestinationScrapListRequestDTO: Encodable {
  let folderName: String
  let page: Int32?
  let perPage: Int32?
}
