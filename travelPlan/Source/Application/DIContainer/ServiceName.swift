//
//  ServiceName.swift
//  travelPlan
//
//  Created by 양승현 on 6/4/24.
//

import Foundation
import Swinject

@frozen public enum ServiceName: String {
  /// Firebase를 활용한 객체들을 호출할 때 사용됩니다.
  case firebase
  case jsonMock
  case stub
}
