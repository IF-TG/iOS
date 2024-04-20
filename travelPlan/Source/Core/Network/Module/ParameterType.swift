//
//  ParameterType.swift
//  travelPlan
//
//  Created by 양승현 on 3/3/24.
//

import Foundation

enum ParameterType {
  case query(Encodable?)
  case body(Encodable?)
}
