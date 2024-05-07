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
    return toString(from: date, format: format)
  }
  
  /// Date를 주어진 format 형식의 문자열로 변환합니다.
  static func toString(from date: Date, format: String = "yyyy.MM.dd") -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    return dateFormatter.string(from: date)
  }
  
  /// 주어진 날짜, createAt이 Interval에 따라서 Calender.current로부터 몇일, 주 달..전인지 문자열로 반환합니다.
  static func timeAgo(from createAt: Timestamp) -> String {
    let date = createAt.dateValue()
    return timeAgo(from: date)
  }
  
  /// 주어진 날짜, createAt이 Interval에 따라서 Calender.current로부터 몇일, 주 달..전인지 문자열로 반환합니다.
  static func timeAgo(from createAt: Date) -> String {
    let currentDate = Date()
    let calender = Calendar.current
    
    let interval = calender.dateComponents(
      [.year, .month, .weekOfMonth, .day, .hour, .minute],
      from: createAt,
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
    let startDateValue = startDate.dateValue()
    let endDatevalue = endDate.dateValue()
    
    return period(from: startDateValue, to: endDatevalue)
  }
  
  static func period(from startDate: Date, to endDate: Date) -> String {
    let calender = Calendar.current
    let interval = calender.dateComponents(
      [.day, .weekOfYear, .month, .year],
      from: startDate,
      to: endDate)
    
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
    return periodYMD(from: startDate.dateValue(), to: endDate.dateValue())
  }
  
  static func periodYMD(from startDate: Date, to endDate: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy.MM.dd"
    
    let start = formatter.string(from: startDate)
    let end = formatter.string(from: endDate)
    
    return "\(start) ~ \(end)"
  }
  
  /// yyyy.MM.dd형식의 문자열을 Date로 변환합니다.
  static func toDate(from ymdString: String) -> Date? {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy.MM.dd"
    return formatter.date(from: ymdString)
  }
  
  static func toDate(from timestamp: Timestamp) -> Date {
    return timestamp.dateValue()
  }
}
