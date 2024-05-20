//
//  CourseEntity.swift
//  travelPlan
//
//  Created by SeokHyun on 5/18/24.
//

import Foundation

struct CourseEntity {
  let tourContentId: TourContentId
  let distance: String
  let telNumber: String
  let requiredTime: String
  let title: String
  let address: String
  let overview: String
  let imageDataList: [Data?]
}
