//
//  SubPathType.swift
//  travelPlan
//
//  Created by 양승현 on 10/12/23.
//

import Foundation

enum RequestType {
  case none
  /// 사용자 이름 중복 체크와 사용자 이름 업데이트 두 개의 로직에서 사용중
  case userNameDuplicateCheck
  case post(Post)
  case userProfile(UserProfile)
  case custom(String)
  
  var path: String {
    return switch self {
    case .none:
      ""
    case .userNameDuplicateCheck:
      "nickname"
    case .post(let post):
      post.path
    case .userProfile(let profile):
      profile.path
    case .custom(let requestPath):
      requestPath
    }
  }
}

// MARK: - Nested
extension RequestType {
  enum Post {
    case postsFetch
    
    var path: String {
      switch self {
      case .postsFetch:
         "posts"
      }
    }
  }
  
  enum UserProfile {
    case update
    case save
    case delete
    case fetch
    
    var path: String {
      "profile" + relativePath
    }
    
    private var relativePath: String {
      return switch self {
      case .update:
        "/upload"
      case .save:
        "/upload"
      case .delete:
        ""
      case .fetch:
        "/original"
      }
    }
  }
}
