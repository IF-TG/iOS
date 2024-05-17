//
//  FestivalEntity.swift
//  travelPlan
//
//  Created by SeokHyun on 4/29/24.
//

import Foundation

// 축제(행사)
struct FestivalEntity {
  let tourContentId: TourContentId
  let ageLimit: String
  let startDate: Date?
  let endDate: Date?
  let address: String
  let showTime: String
  let fee: String
  let title: String
  let images: [Data?]
  let telNumber: String
  let overview: String
}
