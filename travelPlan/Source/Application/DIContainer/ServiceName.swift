//
//  ServiceName.swift
//  travelPlan
//
//  Created by 양승현 on 6/4/24.
//

import Foundation
import Swinject

@frozen public enum ServiceName: RawRepresentable {
  case implementation(ImplementationResolveType)
  case testDouble(TestDoubleResolveType)
  
  public typealias RawValue = String
  
  public var rawValue: String {
    switch self {
    case .implementation(let impl):
      return impl.rawValue
    case .testDouble(let testDouble):
      return testDouble.rawValue
    }
  }
  
  public init?(rawValue: RawValue) {
    if let impl = ImplementationResolveType(rawValue: rawValue) {
      self = .implementation(impl)
    } else if let testDouble = TestDoubleResolveType(rawValue: rawValue) {
      self = .testDouble(testDouble)
    } else {
      return nil
    }
  }
}

@frozen public enum ImplementationResolveType: String {
  /// Spring server와 통신하는 구현체.
  case `default`
  /// Firestore와 통신하는 구현체
  case firestore
}

@frozen public enum TestDoubleResolveType: String {
  case mock, stub, dummy
}
