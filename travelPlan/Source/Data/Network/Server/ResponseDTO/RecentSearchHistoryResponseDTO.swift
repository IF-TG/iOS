//
//  RecentSearchHistoryResponseDTO.swift
//  travelPlan
//
//  Created by SeokHyun on 7/18/24.
//

import Foundation

struct RecentSearchHistoryResponseDTO: Decodable {
  let history: String
  let createAt: String
}

// MARK: - Mapping Domain
extension RecentSearchHistoryResponseDTO {
  func toDomain() -> RecentSearchHistory {
    let formatter = DateFormatter()
    formatter.dateFormat = "yy:MM:dd HH:mm"
    
    return .init(keyword: history, createAt: formatter.date(from: createAt))
  }
}

