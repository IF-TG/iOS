//
//  PostViewSection.swift
//  travelPlan
//
//  Created by 양승현 on 3/21/24.
//

import Foundation

// 오랜만에 0, 1, 2로되어있는 CollectionViewDataSource를 보니 까먹었다 코드보며 기억이나서 타입화 했습니다.
@frozen enum PostViewSection: Int, CaseIterable {
  /// 오더타입, 메인테마 section
  case category = 0
  /// 포스트 section
  case post = 1
  /// refresh section
  case bottomRefresh = 2
  
  static var count: Int {
    return allCases.count
  }
}
