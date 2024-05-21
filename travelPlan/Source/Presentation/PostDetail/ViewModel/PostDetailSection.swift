//
//  PostDetailSection.swift
//  travelPlan
//
//  Created by 양승현 on 5/21/24.
//

import Foundation

@frozen enum PostDetailSection {
  /// 0
  case postDescription
  /// 1
  case postContent
  /// 2
  case postHeartAndShareArea
  
  /// 3 이상부터는 comments가 있습니다.
  case comments(Int)
  
  /// 댓글 섹션은 3부터 시작합니다.
  static let defaultNumberOfSections = 3
  
  static func commentIndex(section: Int) -> Int {
    section - defaultNumberOfSections
  }
  
  /// 댓글을 기준으로 0부터 시작해서 원하는 commentIndex에 접근할 수 있습니다.
  /// 
  /// Notes:
  /// 1. CommentEntity리스트에서 index 0은 PostDetailSection의 3을 뜻합니다.
  ///     - 즉, Entity 자료구조에 접근할 때는 commentIndex로 변환해서 접근해야만 합니다.
  ///     - 반대로 postDetailSection에서 해당 commentEntity commentIndex에 대응하는 값을 뷰에게 전달할때는 rawValue를 사용해야합니다.
  var commentIndex: Int {
    rawValue - PostDetailSection.defaultNumberOfSections
  }
}

// MARK: - RawRepresentable 
extension PostDetailSection: RawRepresentable {
  typealias RawValue = Int
  init(rawValue: Int) {
    switch rawValue {
    case 0:
      self = .postDescription
    case 1:
      self = .postContent
    case 2:
      self = .postHeartAndShareArea
    default:
      self = .comments(rawValue)
    }
  }
  
  var rawValue: Int {
    switch self {
    case .postDescription:
      return 0
    case .postContent:
      return 1
    case .postHeartAndShareArea:
      return 2
    case .comments(let indexPathRow):
      return indexPathRow
    }
  }
}
