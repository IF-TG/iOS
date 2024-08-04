//
//  CultureFacilityEntity.swift
//  travelPlan
//
//  Created by SeokHyun on 5/16/24.
//

import Foundation

struct CultureFacilityEntity {
  let tourContentId: TourContentId
  let telNumber: String
  let availableTime: String
  let canPark: String
  let canAccompanyDog: String
  let restDay: String
  let address: String
  let title: String
  let overview: String
  let imageDataList: [Data?]
}
