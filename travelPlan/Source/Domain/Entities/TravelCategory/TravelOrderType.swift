//
//  TravelOrderType.swift
//  travelPlan
//
//  Created by 양승현 on 2023/09/13.
//

import Foundation

@frozen enum TravelOrderType: String, CaseIterable, Equatable, RawRepresentable {
  case newest = "최신순"
  case popularity = "인기순"
  
  init?(rawValue: String) {
    switch rawValue {
    case TravelOrderType.newest.rawValue:
      self = .newest
    case TravelOrderType.popularity.rawValue:
      self = .popularity
    default:
      return nil
    }
  }
}
