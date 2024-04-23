//
//  TourApiDetailCommonResponseDTO.swift
//  travelPlan
//
//  Created by 양승현 on 4/20/24.
//

import Foundation

struct TourApiDetailCommonResponseDTO: Decodable {
  /// **기본 정보 조화**
  let contentid: String
  let contenttypeid: String
  let tel: String
  let telname: String
  
  /// **주소 정보 조회**
  let addr1: String
  /// 상세 주소
  let addr2: String
  
  /// **좌표 정보 조회**
  let mapx: String
  let mapy: String
  
  let overview: String
}

// MARK: - Mappings to Domain
extension TourApiDetailCommonResponseDTO {
  func toDomain() -> TourDestinationDetailCommonEntity {
    .init(
      id: .init(contentId: contentid, contentTypeId: contenttypeid),
      address: .init(address1: addr1, address2: addr2),
      contact: .init(telNumber: tel, telName: telname),
      coordinate: .init(mapX: mapx, mapY: mapy),
      overview: overview)
  }
}
