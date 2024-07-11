//
//  TravelRegion+PlanCategorySelectionConfigurable.swift
//  travelPlan
//
//  Created by 양승현 on 6/30/24.
//

import Foundation

extension TravelRegion: PlanCategorySelectionConfigurable {
  var toPlanSelectionCategory: String {
    switch self {
    case .seoul:
      "서울"
    case .busan:
      "부산"
    case .incheon:
      "인천"
    case .daegu:
      "대구"
    case .gwangju:
      "광주"
    case .daejeon:
      "대전"
    case .ulsan:
      "울산"
    case .sejong:
      "세종"
    case .gyeonggido:
      "경기"
    case .chungcheongbukdo:
      "충북"
    case .chungcheongnamdo:
      "충남"
    case .jeollabukdo:
      "전북"
    case .jeollanamdo:
      "전남"
    case .gyeongsangbukdo:
      "경북"
    case .gyeongsangnamdo:
      "경남"
    case .gangwonSpecialSelfGoverningProvince:
      "강원"
    case .jejuSpecialSelfGoverningProvince:
      "제주"
    }
  }
}
