//
//  LeportsEntity.swift
//  travelPlan
//
//  Created by SeokHyun on 5/15/24.
//

import Foundation

struct LeportsEntity {
  let tourContentId: TourContentId
  let operationPeriod: String
  let telNumber: String
  let restDay: String
  let availableTime: String
  let canPark: String
  let canAccompanyDog: String
  let fee: String
  let title: String
  let overview: String
  let imageDataList: [Data?]
  let address: String
}
