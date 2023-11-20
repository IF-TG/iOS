//
//  CacheConfiguration.swift
//  travelPlan
//
//  Created by 양승현 on 11/20/23.
//

import Foundation

public struct CacheConfiguration {
  let maximumCount: Int
  let memoryLimit: Int
  let entryLifetime: TimeInterval
  
  static let `default` = CacheConfiguration(
    maximumCount: 100,
    memoryLimit: 1024 * 1024 * 300,
    entryLifetime: 6 * 60 * 60)
}
