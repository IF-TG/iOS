//
//  DestinationSearchRepository.swift
//  travelPlan
//
//  Created by SeokHyun on 7/14/24.
//

import Foundation
import Combine

protocol DestinationSearchRepository {
  /// 검색 결과를 기반으로 여행지 리스트를 받아옵니다.
  func fetchDestinationList(
    by keyword: String,
    page: Int32?,
    perPage: Int32?
  ) -> AnyPublisher<[ThumbnailDestination], any Error>
}
