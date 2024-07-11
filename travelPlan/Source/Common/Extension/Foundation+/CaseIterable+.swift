//
//  CaseIterable+.swift
//  travelPlan
//
//  Created by 양승현 on 2023/09/13.
//

import Foundation

extension CaseIterable where Self: RawRepresentable {
  static var count: Int {
    Self.allCases.count
  }
}

extension CaseIterable where Self: RawRepresentable, Self.RawValue == String {
  static var toKoreanList: [String] {
    allCases.map { $0.rawValue }
  }
}
