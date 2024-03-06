//
//  TravelOrderType.swift
//  travelPlan
//
//  Created by 양승현 on 2023/09/13.
//

import Foundation

@frozen enum TravelOrderType: String, CaseIterable, Equatable {
  case newest = "최신순"
  case popularity = "인기순"
}
