//
//  DateTimeConverter.swift
//  travelPlan
//
//  Created by 양승현 on 5/1/24.
//

import Foundation
import FirebaseFirestore

struct DateTimeConverter {
  private init() {}
  
  /// Timestamp를 주어진 format 형식의 문자열로 변환합니다.
  static func toString(from timestamp: Timestamp, format: String = "yyyy.MM.dd") -> String {
    let date = timestamp.dateValue()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    return dateFormatter.string(from: date)
  }
  
  /// 주어진 날짜, createAt이 Interval에 따라서 Calender.current로부터 몇일, 주 달..전인지 문자열로 반환합니다.
  static func timeAgo(from createAt: Timestamp) -> String {
    let date = createAt.dateValue()
    let currentDate = Date()
    let calender = Calendar.current
    
    let interval = calender.dateComponents(
      [.year, .month, .weekOfMonth, .day, .hour, .minute],
      from: date,
      to: currentDate)
    
    if let years = interval.year, years > 0 {
      return "\(years)년 전"
    } else if let months = interval.month, months > 0 {
      return "\(months)달 전"
    } else if let weeks = interval.weekOfMonth, weeks > 0 {
      return "\(weeks)주 전"
    } else if let days = interval.day, days > 0 {
      return "\(days)일 전"
    } else if let hours = interval.hour, hours > 0 {
      return "\(hours)시간 전"
    } else if let minutes = interval.minute, minutes > 0 {
      return "\(minutes)분 전"
    } else {
      return "방금 전"
    }
  }
  
  static func period(from startDate: Timestamp, to endDate: Timestamp) -> String {
    let calender = Calendar.current
    let startDateValue = startDate.dateValue()
    let endDatevalue = endDate.dateValue()
    
    let interval = calender.dateComponents(
      [.day, .weekOfYear, .month, .year],
      from: startDateValue,
      to: endDatevalue)
    
    if let years = interval.year, years > 0 {
      return "\(years)년 동안"
    } else if let months = interval.month, months > 0 {
      return "\(months)달 동안"
    } else if let weeks = interval.weekOfYear, weeks > 0 {
      if let days = interval.day, days > 0 {
        return "\(weeks)주 \(days)일 동안"
      } else {
        return "\(weeks)주 동안"
      }
    } else if let days = interval.day, days > 0 {
      return "\(days)일 동안"
    } else {
      return "하루 동안"
    }
  }
  
  /// form, to 간의 yyyy.MM.dd 날자를 반환합니다.
  static func periodYMD(from startDate: Timestamp, to endDate: Timestamp) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy.MM.dd"
    
    let start = formatter.string(from: startDate.dateValue())
    let end = formatter.string(from: endDate.dateValue())
    
    return "\(start) ~ \(end)"
  }
}
