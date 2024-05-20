//
//  StubImageMemoryCache.swift
//  travelPlanTests
//
//  Created by 양승현 on 5/20/24.
//

import Combine
import Foundation
@testable import travelPlan

final class StubImageMemoryCache: ImageMemoryCachable {
  private let mockImageData = "데이터 존재".data(using: .utf8)!
  
  func imageData(for url: String) -> Data? {
    return mockImageData
  }
  
  func insert(_ imageData: Data, forKey url: String) { }
  
  func removeImageData(for url: String) { }
  
  func removeAllImages() { }
  
  subscript(url: String) -> Data? {
    get { mockImageData }
    set { print(newValue as Any) }
  }
}
