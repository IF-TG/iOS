//
//  ThumbnailDestination.swift
//  travelPlan
//
//  Created by SeokHyun on 7/14/24.
//

import Foundation

struct ThumbnailDestination {
  let id: Id
  let title: String
  let thumbnailURL: String
  let address: String
  let category: Category
  var isScraped: Bool
  
  struct Category {
    let largeCategory: String
    let middleCategory: String
    let smallCategory: String
  }
  
  struct Id {
    let id: Int64
    let contentTypeId: Int32
  }
}
