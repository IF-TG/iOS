//
//  Error+PaginationError.swift
//  travelPlan
//
//  Created by 양승현 on 5/16/24.
//

import Foundation

public extension Swift.Error {
  var isNoMorePage: Bool {
    guard let error = self as? PaginationError else {
      return false
    }
    if error == .noMorePage {
      return true
    }
    return false
  }
  
  var isPageNumberError: Bool {
    guard let error = self as? PaginationError else {
      return false
    }
    if error == .invalidPageNumberError {
      return true
    }
    return false
  }
}
