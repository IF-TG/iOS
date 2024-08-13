//
//  DestinationRecommendSection.swift
//  travelPlan
//
//  Created by SeokHyun on 8/8/24.
//

import Foundation

struct DestinationRecommendSection {
  let title: String
  let destinations: [Destination]
  
  struct Destination {
    let destinationId: DestinationIdEntity
    let title: String
    let thumbnailData: Data?
    let address: String
    let category: DestinationCategory
    var isScaped: Bool
  }
}
