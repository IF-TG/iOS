//
//  TourDestinationDetailCommonEntity.swift
//  travelPlan
//
//  Created by 양승현 on 4/20/24.
//

import Foundation

struct TourDestinationDetailCommonEntity {
  /// **기본 정보 조화**
  let contentId: Int
  let contentTypeId: Int
  let telNumber: String
  let telName: String
  
  /// **주소 정보 조회**
  let address1: String
  /// 상세 주소
  let address2: String
  
  /// **좌표 정보 조회**
  let mapx: Double
  let mapy: Double
  
  let overview: String
}
