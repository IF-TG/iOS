//
//  MainError.swift
//  travelPlan
//
//  Created by 양승현 on 3/1/24.
//

import Foundation

enum MainError: Swift.Error {
  case general(String)
  case networkError(NetworkError)
  case referenceError(ReferenceError)
}

// MARK: - CustomStringConvertible
extension MainError: CustomStringConvertible {
  var description: String {
    switch self {
    case .general(let reason):
      return "DEBUG: General error occured: \(reason)"
    case .networkError(let networkError):
      return "DEBUG: Network error occured: \(networkError.localizedDescription)"
    case .referenceError(let referenceError):
      return "DEBUG: Reference error occured: \(referenceError.localizedDescription)"
    }
  }
}
