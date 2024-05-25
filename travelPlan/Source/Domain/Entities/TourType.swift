//
//  TourType.swift
//  travelPlan
//
//  Created by SeokHyun on 5/10/24.
//

import Foundation

@frozen
enum TourType: Int, CaseIterable {
  /// 관광지
  case attraction = 12
  /// 문화시설
  case cultureFacility = 14
  /// 축제/공연/행사
  case festival = 15
  /// 여행코스
  case course = 25
  /// 레포츠
  case leports = 28
  /// 숙박
  case accommodation = 32
  /// 쇼핑
  case shopping = 38
  /// 음식점
  case restaurant = 39
  
  var toString: String {
    switch self {
    case .attraction: return "관광지"
    case .cultureFacility: return "문화시설"
    case .festival: return "축제/공연/행사"
    case .course: return "여행코스"
    case .leports: return "레포츠"
    case .accommodation: return "숙박"
    case .shopping: return "쇼핑"
    case .restaurant: return "음식점"
    }
  }
}
