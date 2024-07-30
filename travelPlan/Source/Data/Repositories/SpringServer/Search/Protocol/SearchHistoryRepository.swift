//
//  RecentSearchHistoryRepository.swift
//  travelPlan
//
//  Created by SeokHyun on 7/18/24.
//

import Foundation
import Combine

protocol RecentSearchHistoryRepository {
  /// 최근 검색 기록을 가져옵니다.
  func fetchRecentSearchHistory(
    page: Int?,
    perPage: Int?
  ) -> AnyPublisher<[RecentSearchHistory], any Error>
  
  // TODO: - Delete All
  // TODO: - Delete Element
}
