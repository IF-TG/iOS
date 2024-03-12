//
//  MainError.swift
//  travelPlan
//
//  Created by 양승현 on 3/1/24.
//

import Foundation
import Alamofire

enum MainError: Swift.Error {
  case general(String)
  case networkError(AFError)
  case referenceError(ReferenceError)
  case authService(AuthenticationServiceError)
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
    default:
      return "DEBUG: MainError occured: \(self.localizedDescription)"
    }
  }
}
