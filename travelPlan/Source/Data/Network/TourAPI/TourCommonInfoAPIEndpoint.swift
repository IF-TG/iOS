//
//  TourCommonInfoAPIEndpoint.swift
//  travelPlan
//
//  Created by 양승현 on 4/20/24.
//

import Foundation

/// 검색 결과 섬네일 화면에서 특정 여행지 상세 화면으로 들어갈 때 연관된 데이터들을 호출할 수 있는 Endpoint입니다..
struct TourCommonInfoAPIEndpoint {
  static func makeCommonInfoAPIEndpoint(
    with requestDTO: TourApiCommonInfoRequestDTO
  ) -> TourApiEndpoint<TourApiCommonResponseDTO<TourApiCommonInfoResponseDTO>> {
    return .init(
      parameters: .query(requestDTO),
      requestType: .detailCommon)
  }
}
