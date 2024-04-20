//
//  TourApiDetailCommonRequestDTO.swift
//  travelPlan
//
//  Created by 양승현 on 4/20/24.
//

import Foundation

final class TourApiDetailCommonRequestDTO: TourApiBaseRequestDTO {
  let contentId: Int
  let addrinfoYN = "Y"
  let mapinfoYN = "Y"
  let overviewYN = "Y"
  let defaultYN = "Y"
  
  /// 여기선 사실상 contentId에 따라서 특정한 한 데이터만 받아올 것으로 예상되어 페이징이 의미 없습니다.
  init(
    contentId: Int,
    numOfRows: Int?,
    pageNo: Int?,
    keyType: APIManager.APIKeyType
  ) {
    self.contentId = contentId
    super.init(numOfRows: 10, pageNo: 1, keyType: keyType)
  }
}
