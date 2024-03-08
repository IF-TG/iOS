//
//  ReferenceError.swift
//  travelPlan
//
//  Created by 양승현 on 3/1/24.
//

import Foundation

enum ReferenceError: Swift.Error {
  case weakSelfError
  case unownedSelfError
  case other(String)
}

// MARK: - LocalizedError
extension ReferenceError: LocalizedError {
  var errorDescription: String? {
    switch self {
    case .weakSelfError:
      return NSLocalizedString("DEBUG: Weak self reference error occurred", comment: "")
    case .unownedSelfError:
      return NSLocalizedString("DEBUG: Unowned self reference error occurred", comment: "")
    case .other(let description):
      return "DEBUG: Unexpected reference error occured: \(description)"
    }
  }
}
