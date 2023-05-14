//
//  PostHeaderSubInfoModel.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/14.
//

import UIKit

struct PostHeaderSubInfoModel {
  let userName: String
  let duration: String
  let yearMonthDayRange: String
}

extension PostHeaderSubInfoModel {
  func isValidatedUsername() -> Bool {
    if !userName.isEmpty || userName.count >= 3 {
      return true
    }
    return false
  }
  
  func isValidatedDuration() -> Bool {
    if !duration.isEmpty { return true }
    return false
  }
  
  func isValidatedYearMonthDayRange(
    fromDateValidationManager manager: DateValidationProtocol
  ) -> Bool {
    if manager.isValidDateRange(from: yearMonthDayRange) {
      return true
    }
    return false
  }
}
