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
  case custom(String)
  case userProfileUpdate
  case userProfileSave
  case userProfileDelete
  case userProfileFetch
  
  var path: String {
    switch self {
    case .none:
      return ""
    case .userNameDuplicateCheck:
      return "nickname"
<<<<<<< HEAD
    case .post(let post):
      return post.path
=======
    case .userProfileUpdate:
      return "profile/upload"
    case .userProfileSave:
      return "profile/upload"
    case .userProfileDelete:
      return "profile"
    case .userProfileFetch:
      return "profile/original"
>>>>>>> 220fedaf531e35b62800cc1c640812d7f5e17c02
    case .custom(let requestPath):
      return requestPath
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
}
