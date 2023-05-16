//
//  PostThumbnailType.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/13.
//

enum PostThumbnailType: CaseIterable {
  case one
  case two
  case three
  case four
  case five // or many
  
  var value: Int {
    switch self {
    case .one: return 1
    case .two: return 2
    case .three: return 3
    case .four: return 4
    case .five: return 5
    }
  }
  
  init(fromInt value: Int) {
    switch value {
    case 1: self = .one
    case 2: self = .two
    case 3: self = .three
    case 4: self = .four
    case 5: self = .five
    default: self = .five
    }
  }
}
