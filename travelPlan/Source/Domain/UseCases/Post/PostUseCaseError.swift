//
//  PostUseCaseError.swift
//  travelPlan
//
//  Created by 양승현 on 5/16/24.
//

import Foundation

@frozen enum PostUseCaseError: LocalizedError {
  case noMorePage
  
  var errorDescription: String? {
    return switch self {
    case .noMorePage:
      "더 이상의 페이지가 존재하지 않습니다."
    }
  }
}
