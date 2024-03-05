//
//  TravelTheme.swift
//  travelPlan
//
//  Created by 양승현 on 2023/09/13.
//

import Foundation

enum TravelTheme: String, CaseIterable {
  case relaxation = "휴식"
  case shopping = "쇼핑"
  case campingGlamping = "캠핑/글램핑"
  case adventure = "모험"
  case local = "현지 체험"
  case festivals = "축제"
}

extension TravelTheme {
  func toDTO() -> String {
    return switch self {
    case .relaxation:
      "REST"
    case .shopping:
      "SHOPPING"
    case .campingGlamping:
      "CAMPING_GLAMPING"
    case .adventure:
      "ADVENTURE"
    case .local:
      "LOCAL_EXPERIENCE"
    case .festivals:
      "FESTIVAL"
    }
  }
}
