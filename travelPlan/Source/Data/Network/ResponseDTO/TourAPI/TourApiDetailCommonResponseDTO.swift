//
//  TourApiDetailCommonResponseDTO.swift
//  travelPlan
//
//  Created by 양승현 on 4/20/24.
//

import Foundation

final class TourApiDetailCommonResponseDTO: TourApiBaseResponseDTO, Decodable {
  var resultCode: String
  var resultMsg: String
  var numOfRows: Int
  var pageNo: Int
  var totalCount: Int
  
  /// **기본 정보 조화**
  let contentid: Int
  let contenttypeid: Int
  let tel: String
  let telname: String
  
  /// **주소 정보 조회**
  let addr1: String
  /// 상세 주소
  let addr2: String
  
  /// **좌표 정보 조회**
  let mapx: Double
  let mapy: Double
  
  let overview: String
}
