//
//  CacheConfiguration.swift
//  travelPlan
//
//  Created by 양승현 on 11/20/23.
//

struct CacheConfiguration {
  let maximumCount: Int
  let memoryLimit: Int
  
  static let `default` = CacheConfiguration(maximumCount: 100, memoryLimit: 1024 * 1024 * 300)
  }
