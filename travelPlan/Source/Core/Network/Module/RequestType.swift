//
//  SubPathType.swift
//  travelPlan
//
//  Created by 양승현 on 10/12/23.
//

import Foundation

enum RequestType {
  case none
  case userNameDuplicateCheck
  case custom(String)
  
  var path: String {
    switch self {
    case .none:
      return ""
    case .userNameDuplicateCheck:
      return "nickname"
    case .custom(let requestPath):
      return requestPath
    }
  }
}
