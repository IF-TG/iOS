//
//  TextDelimiterHelper.swift
//  travelPlan
//
//  Created by SeokHyun on 11/25/23.
//

import Foundation

struct TextDelimiterHelper {
  private(set) var lastIndex: Int = 0
  private(set) var symbol = "∆∑©"
  
  mutating func getDelimiter() -> String {
    let index = self.lastIndex
    self.lastIndex += 1
    return "{" + symbol + "\(index)" + "}"
  }
}
