//
//  TourDestinationDetailCommonEntity.swift
//  travelPlan
//
//  Created by 양승현 on 4/20/24.
//

import Foundation

struct TourDestinationDetailCommonEntity {
  let id: Id
  let address: addressInfo
  let contact: ContactInfo
  let coordinate: Coordinate
  let overview: String
}

extension TourDestinationDetailCommonEntity {
  /// **기본 정보 조회**
  struct Id {
    let contentId: Int
    let contentTypeId: Int
  }
  
  /// **좌표 정보 조회**
  struct Coordinate {
    let mapX: Double
    let mapY: Double
  }
  
  /// **컨텐츠 연락 정보**
  struct ContactInfo {
    let telNumber: String
    let telName: String
  }
  
  /// **주소 정보 조회**
  struct addressInfo {
    let address1: String
    /// 상세 주소
    let address2: String
  }
}
