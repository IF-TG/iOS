//
//  Error+OwnerError.swift
//  travelPlan
//
//  Created by 양승현 on 5/17/24.
//

import Foundation.FoundationErrors

public extension Swift.Error {
  var isInvalidOwnerId: Bool {
    guard let error = self as? OwnerError else {
      return false
    }
    if error == .invalidOwnerId {
      return true
    }
    return false
  }
}
