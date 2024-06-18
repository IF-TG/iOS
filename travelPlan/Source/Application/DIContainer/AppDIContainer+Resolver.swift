//
//  AppDIContainer+Resolver.swift
//  travelPlan
//
//  Created by 양승현 on 6/5/24.
//

import Foundation

extension AppDIContainer {  
  func resolve<Service>(_: Service.Type) -> Service? {
    return resolver.resolve(Service.self)
  }
  
  func resolve<Service>(_: Service.Type, name: ServiceName?) -> Service? {
    return resolver.resolve(Service.self, name: name)
  }
  
  /// 뷰컨트롤러나 코디네이터를 사용할 때 목, 스터브 객체가 없는 경우에 호출합니다.
  func resolve<Service>(_: Service.Type, name: String? = nil) -> Service? {
    return resolver.resolve(Service.self, name: name)
  }
  
  func resolve<Service, Arg1>(_: Service.Type, name: String? = nil, argument: Arg1) -> Service? {
    return resolver.resolve(Service.self, name: name, argument: argument)
  }
  
  func resolve<Service, Arg1, Arg2>(
    _: Service.Type, name: String? = nil, arguments arg1: Arg1, _ arg2: Arg2
  ) -> Service? {
    return resolver.resolve(Service.self, name: name, arguments: arg1, arg2)!
  }
  
  func resolve<Service, Arg1, Arg2, Arg3>(
    _: Service.Type, name: String? = nil, arguments arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3
  ) -> Service? {
    return resolver.resolve(Service.self, name: name, arguments: arg1, arg2, arg3)!
  }
  
  // swiftlint:disable:next function_parameter_count
  func resolve<Service, Arg1, Arg2, Arg3, Arg4, Arg5>(
    _: Service.Type,
    name: String? = nil,
    arguments arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4, _ arg5: Arg5
  ) -> Service? {
    return resolver.resolve(Service.self, name: name, arguments: arg1, arg2, arg3, arg4, arg5)!
  }
  
  // swiftlint:disable:next function_parameter_count
  func resolve<Service, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7>(
    _: Service.Type,
    name: String? = nil,
    arguments arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4, _ arg5: Arg5, _ arg6: Arg6, _ arg7: Arg7
  ) -> Service? {
    return resolver.resolve(Service.self, name: name, arguments: arg1, arg2, arg3, arg4, arg5, arg6, arg7)!
  }
}
