//
//  Container+.swift
//  travelPlan
//
//  Created by 양승현 on 6/4/24.
//

import Foundation
import Swinject

public extension Container {
  ///
  /// - Parameters:
  ///   - serviceType: 등록해야할 서비스의 Metatype을 as a value로 전달합니다.
  ///   - name: protocol을 등록시 String이 아닌 ResolveType의 Raw representable을 등록해 오류를 최소화 합니다.
  ///   - factory: service's type이 dependencies와 함께 resolved되는 방법을 명시합니다.
  @discardableResult
  @inline(__always)
  func register<Service>(
    _ serviceType: Service.Type,
    name: ResolveType? = nil,
    factory: @escaping (Resolver) -> Service
  ) -> ServiceEntry<Service> {
    register(serviceType, name: name, factory: factory)
  }
}

