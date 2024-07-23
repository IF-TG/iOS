//
//  SearchHistoryEndpoints.swift
//  travelPlan
//
//  Created by SeokHyun on 7/18/24.
//

import Foundation

struct SearchHistoryEndpoints {
  static func fetchRecentHistory(
    with requestDTO: RecentSearchHistoryRequestDTO
  ) -> Endpoint<CommonDTO<[RecentSearchHistoryResponseDTO]>> {
    return .init(
      scheme: "http",
      host: "localhost:8080",
      method: .get,
      parameters: [.query(requestDTO)],
      requestType: .searchHistory(.getRecentSearchHistory)
    )
  }
  
  // TODO: - fetchRecommendationHistory
}




