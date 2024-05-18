//
//  RestaurantEntity.swift
//  travelPlan
//
//  Created by SeokHyun on 5/16/24.
//

import Foundation

struct RestaurantEntity {
  let toutContentId: TourContentId
  let signatureDish: String
  let menu: String
  let telNumber: String
  let canPark: String
  let businessHour: String
  let restDay: String
  let title: String
  let address: String
  let overview: String
  let imageDataList: [Data?]
}
