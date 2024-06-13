//
//  Resolver+.swift
//  travelPlan
//
//  Created by 양승현 on 6/4/24.
//

import Foundation
import Swinject

public extension Resolver {
  /// Resolver에서 a service resolve
  ///
  /// - Parameters:
  ///   - serviceType: resolve해야 할 서비스의 Metatype을 as a value로 전달합니다.
  ///   - name: Service를 container에서 꺼내올때 구현체가 여러개인 경우 name으로 식별합니다.
  @inline(__always)
  func resolve<Service>(_: Service.Type, name: ServiceName?) -> Service? {
    return resolve(Service.self, name: name?.rawValue)
  }
  
  func resolve<Service, Arg1>(_: Service.Type, name: ServiceName?, argument: Arg1) -> Service? {
    return resolve(Service.self, name: name?.rawValue, argument: argument)
  }
  
  func resolve<Service, Arg1, Arg2>(
    _: Service.Type,
    name: ServiceName?,
    arguments arg1: Arg1, _ arg2: Arg2
  ) -> Service? {
    return resolve(Service.self, name: name?.rawValue, arguments: arg1, arg2)
  }
  
  func resolve<Service, Arg1, Arg2, Arg3>(
    _: Service.Type,
    name: ServiceName?,
    arguments arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3
  ) -> Service? {
    return resolve(Service.self, name: name?.rawValue, arguments: arg1, arg2, arg3)
  }
}
