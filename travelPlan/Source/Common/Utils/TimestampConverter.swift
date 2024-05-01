//
//  TimestampConverter.swift
//  travelPlan
//
//  Created by 양승현 on 5/1/24.
//

import Foundation
import FirebaseFirestore

struct TimestampConverter {
  /// Timestamp를 주어진 format 형식의 문자열로 변환합니다.
  static func toString(from timestamp: Timestamp, format: String = "yyyy.MM.dd") -> String {
    let date = timestamp.dateValue()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    return dateFormatter.string(from: date)
  }
  
  /// 주어진 날짜, createAt이 Interval에 따라서 Calender.current로부터 몇일, 주 달..전인지 문자열로 반환합니다.
  static func toTimeAgoString(from createAt: Timestamp) -> String {
    let date = createAt.dateValue()
    let currentDate = Date()
    var calender = Calendar.current
    
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
    }
  }
}
