//
//  DestinationScrapDetail.swift
//  travelPlan
//
//  Created by SeokHyun on 7/12/24.
//

import Foundation

struct DestinationScrapDetail {
  let id: DestinationIdEntity
  let title: String
  let address: DestinationAddress
  let map: DestinationCoordinate<Double>
  let overview: String
  let tel: String
  let category: DestinationCategory
  let thumbnailImageData: Data?
  let isScraped: Bool
}
