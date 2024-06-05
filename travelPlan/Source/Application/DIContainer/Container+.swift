//
//  Container+.swift
//  travelPlan
//
//  Created by 양승현 on 6/4/24.
//

import Foundation
import Swinject

public extension Container {
  /// Container에 a service register
  ///
  /// - Parameters:
  ///   - serviceType: 등록해야할 서비스의 Metatype을 as a value로 전달합니다.
  ///   - name: protocol을 등록시 String이 아닌 ResolveType의 Raw representable을 등록해 오류를 최소화 합니다.
  ///   - factory: service's type이 dependencies와 함께 resolved되는 방법을 명시합니다.
  @discardableResult
  @inline(__always)
  func register<Service>(
    _ serviceType: Service.Type,
    name: ServiceName,
    factory: @escaping (Resolver) -> Service
  ) -> ServiceEntry<Service> {
    return _register(serviceType, factory: factory, name: name.rawValue)
  }
  
  /// Container에 a service register할 때 인자값이 하나 요구되는 경우에 사용합니다.
  @discardableResult
  @inline(__always)
  func register<Service, Arg1>(
    _ serviceType: Service.Type,
    name: ServiceName,
    factory: @escaping (Resolver, Arg1) -> Service
  ) -> ServiceEntry<Service> {
    return _register(serviceType, factory: factory, name: name.rawValue)
  }
  
  /// Container에 a service register할 때 인자값이 두개 요구되는 경우에 사용합니다.
  @discardableResult
  @inline(__always)
  func register<Service, Arg1, Arg2>(
    _ serviceType: Service.Type,
    name: ServiceName,
    factory: @escaping (Resolver, Arg1, Arg2) -> Service
  ) -> ServiceEntry<Service> {
    return _register(serviceType, factory: factory, name: name.rawValue)
  }
  
  @discardableResult
  @inline(__always)
  func register<Service>(
    _ serviceType: Service.Type,
    factory: @escaping (Resolver) -> Service
  ) -> ServiceEntry<Service> {
    return _register(serviceType, factory: factory, name: nil)
  }
  
  /// Container에 a service resolve
  ///
  /// - Parameters:
  ///   - serviceType: resolve해야 할 서비스의 Metatype을 as a value로 전달합니다.
  ///   - name: Service를 container에서 꺼내올때 구현체가 여러개인 경우 name으로 식별합니다.
  @inline(__always)
  func resolve<Service>(_: Service.Type, name: ServiceName?) -> Service? {
    return resolve(Service.self, name: name?.rawValue)
  }
}
