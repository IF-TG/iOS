//
//  DestinationScrapList.swift
//  travelPlan
//
//  Created by SeokHyun on 7/12/24.
//

import Foundation

struct DestinationScrapDetail {
  let id: Id
  let title: String
  let address: TourAddress
  let map: TourCoordinate<Double>
  let overview: String
  let tel: String
  let category: Category
  let thumbnail: String
  let isScraped: Bool
  
  struct Category {
    let largeCategory: String
    let middleCategory: String
    let smallCategory: String
  }
  
  struct Id {
    let scrapId: Int64
    let contentTypdId: Int32
  }
}
