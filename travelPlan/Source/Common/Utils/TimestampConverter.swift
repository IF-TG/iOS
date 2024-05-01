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
}
