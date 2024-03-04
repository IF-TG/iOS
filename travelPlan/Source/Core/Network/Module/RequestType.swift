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
    case .userProfileUpdate:
      return "profile/upload"
    case .userProfileSave:
      return "profile/upload"
    case .userProfileDelete:
      return "profile"
    case .userProfileFetch:
      return "profile/original"
    case .custom(let requestPath):
      return requestPath
    }
  }
}
