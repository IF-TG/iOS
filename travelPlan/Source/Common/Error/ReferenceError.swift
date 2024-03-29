//
//  ReferenceError.swift
//  travelPlan
//
//  Created by 양승현 on 3/1/24.
//

import Foundation

enum ReferenceError: Swift.Error {
  case invalidReference
}

// MARK: - LocalizedError
extension ReferenceError: LocalizedError {
  var errorDescription: String? {
    switch self {
    case .invalidReference:
      NSLocalizedString("클라이언트에서 에러가 발생했습니다.", comment: "")
    }
  }
}
