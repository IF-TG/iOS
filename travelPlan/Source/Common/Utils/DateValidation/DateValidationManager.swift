//
//  DateValidationManager.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/14.
//

import Foundation

struct DateValidationManager {
  private typealias Err = DateValidationError
  
  // MARK: - Properties
  private let dateFormatter = DateFormatter()
  private let calendar: Calendar
  
  // MARK: - Initialization
  init() {
    dateFormatter.dateFormat = "yyyy.MM.dd"
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    calendar = Calendar.current
  }
}

// MARK: - DateValidationProtocol
extension DateValidationManager: DateValidationProtocol {
  func isValidDateRange(from dateString: String) -> Bool {
    do {
      if !isValidToDateFormatTypeString(dateString) {
      }
      let lists = dateString.components(separatedBy: " ~ ")
      let start = lists[0]
      let end = lists[1]
      if try isValidDateRange(start: start, end: end) {
        return true
      }
      return false
    } catch {
      return false
    }
  }
}

// MARK: - Helpers
private extension DateValidationManager {
  func isValidDateRange(start: String, end: String) throws -> Bool {
    let startDate = try convertToDate(from: start)
    let endDate = try convertToDate(from: end)
    
    let startYMD = calendar.dateComponents(
      [.year, .month, .day], from: startDate)
    let endYMD = calendar.dateComponents(
      [.year, .month, .day], from: endDate)
    
    return try isValidTravelDuration(
      start: (startYMD, startDate),
      end: (endYMD, endDate))
  }
  
  func convertToDate(from dateStr: String) throws -> Date {
    guard let date = dateFormatter.date(from: dateStr) else {
      throw Err.invalidDateFormat
    }
    return date
  }
  
  func isValidToDateFormatTypeString(_ dateString: String) -> Bool {
    if dateString.isEmpty || !dateString.contains(" ~ ") {
      return false
    }
    return true
  }
  
  func isValidTravelDuration(
    start: (YMD: DateComponents, date: Date),
    end: (YMD: DateComponents, date: Date)
  ) throws -> Bool {
    // Start 월년일 최소 date
    guard let startYear = start.YMD.year, startYear >= 1940,
          let startMonth = start.YMD.month, startMonth >= 1, startMonth <= 12,
          let startDay = start.YMD.day, startDay >= 1
    else {
      throw Err.invalidStartTourDate
    }
    // Start 월년일 최소 date
    guard let endYear = end.YMD.year, endYear >= 1940,
          let endMonth = end.YMD.month, endMonth >= 1, endMonth <= 12,
          let endDay = end.YMD.day, endDay >= 1
    else {
      throw Err.invalidEndTourDate
    }
    // 특정 월에서 유효한 day 범위에 있는지
    guard let startMonthRange = calendar.range(of: .day, in: .month, for: start.date),
          let endMonthRange = calendar.range(of: .day, in: .month, for: end.date)
    else {
      throw Err.wrongDay
    }
    if startDay > startMonthRange.count ||
        endDay > endMonthRange.count {
      return false
    }
    return start.date < end.date
  }
}
