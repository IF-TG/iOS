//
//  TourSearchResultEntity.swift
//  travelPlan
//
//  Created by SeokHyun on 5/15/24.
//

import Foundation

struct TourSearchResultEntity {
  let title: String
  let imageData: Image
  let address: Address
  
  struct Image {
    let imageData: Data
    let thumbnailImageData: Data
  }
  
  struct Address {
    let mainAddress: String
    let subAddress: String
  }
}
