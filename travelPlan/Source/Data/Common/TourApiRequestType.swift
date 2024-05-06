//
//  TourApiRequestType.swift
//  travelPlan
//
//  Created by 양승현 on 4/20/24.
//

import Foundation

@frozen enum TourApiRequestType: String, RelativeURLPathProvidable {
  /// 공통정보조회
  case detailCommon = "detailCommon1"
  case detailImage = "detailImage1"
  
  private var prefixPath: String {
    return "/B551011/KorService1"
  }
  
  var path: String {
    let prefix = "B551011/KorService1"
    let relativePath = switch self {
    case .detailCommon:
      self.rawValue
    case .detailImage:
      self.rawValue
    }
    return prefix + "/\(relativePath)"
  }
}
