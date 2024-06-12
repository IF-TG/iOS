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
  /// resolve, register할 때 String으로 name지정이 가능합니다.
  /// 일반적으로 제공되는 register, resolve 함수들을 이용해도 좋지만 이 case를 사용함으로 Dependency 초기화 및 Dependency의 init시점에 받는 값을 단순화 할 수 있습니다.
  case custom(String)
  
  public typealias RawValue = String
  
  public var rawValue: String {
    switch self {
    case .implementation(let impl):
      return impl.rawValue
    case .testDouble(let testDouble):
      return testDouble.rawValue
    case .custom(let serviceName):
      return serviceName
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
  /// Spring server와 통신하는 구현체. 기본 객체
  case `default`
  /// Firestore와 통신하는 구현체
  case firestore
  
  /// URLProtocol을 가로챈 세션을 사용하는 구현체.
  case interceptedDefault
}

@frozen public enum TestDoubleResolveType: String {
  case mock, stub, dummy
}
