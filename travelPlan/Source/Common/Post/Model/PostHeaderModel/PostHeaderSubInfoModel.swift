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
  
  // 데이터가 유효하지 않을 경우
  init(userName: String = "익명",
       duration: String = "미정",
       yearMonthDayRange: String = "20XX.XX.XX ~ 20XX.XX.XX") {
    self.userName = userName
    self.duration = duration
    self.yearMonthDayRange = yearMonthDayRange
  }
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
