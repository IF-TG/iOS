//
//  AttractionEntity.swift
//  travelPlan
//
//  Created by SeokHyun on 5/15/24.
//

import Foundation

struct AttractionEntity {
  let tourContentId: TourContentId
  let restDateString: String
  let telNumber: String
  let availableTime: String
  let canPark: String
  let canAccompanyDog: String
  let experienceInfo: String
  let title: String
  let overview: String
  let address: String
  let imageDataList: [Data?]
}
