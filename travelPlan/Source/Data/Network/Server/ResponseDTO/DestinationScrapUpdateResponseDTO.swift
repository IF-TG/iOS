//
//  DestinationScrapUpdateResponseDTO.swift
//  travelPlan
//
//  Created by SeokHyun on 7/12/24.
//

import Foundation

struct DestinationScrapUpdateResponseDTO: Decodable {
  let objectId: Int64
  let userId: Int64
  let folderName: String
}
