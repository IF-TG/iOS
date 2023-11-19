//
//  SubPathType.swift
//  travelPlan
//
//  Created by 양승현 on 10/12/23.
//

import Foundation

enum RequestType {
  case none
  case custom(String)
  
  var path: String {
    switch self {
    case .none:
      return ""
    case .custom(let requestPath):
      return requestPath
    }
  }
}
