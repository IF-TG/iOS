//
//  PostThumbnailValue.swift
//  travelPlan
//
//  Created by 양승현 on 11/26/23.
//

import Foundation

/// Feed탭의 포스트(사용자 여행 경험 후기)글은 1~5개의 이미지를 갖습니다.
@frozen enum PostThumbnailCountValue {
  case one
  case two
  case three
  case four
  case five
  
  var value: Int {
    switch self {
    case .one: return 1
    case .two: return 2
    case .three: return 3
    case .four: return 4
    case .five: return 5
    }
  }
  
  init(_ value: Int) {
    switch value {
    case 1:
      self = .one
    case 2:
      self = .two
    case 3:
      self = .three
    case 4:
      self = .four
    case 5:
      self = .five
    default:
      self = .one
    }
  }
}

