//
//  SubPathType.swift
//  travelPlan
//
//  Created by 양승현 on 10/12/23.
//

import Foundation

enum ResponseType {
  case none
  
  var path: String {
    switch self {
    case .none:
      return ""
    }
  }
}