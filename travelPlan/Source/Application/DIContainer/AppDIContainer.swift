//
//  YeoGaAssembler.swift
//  travelPlan
//
//  Created by 양승현 on 6/4/24.
//

import Foundation
import Swinject

/// Assembler는 단 하나의 인스턴스만 생겨야 합니다. 또한 앱이 종료되기 전까지 메모리에 로드되어 있음이 보장되야 합니다.
/// Yeoga앱이 실행되기 위해 필요로되는 Layer별 assembly들을 한 곳에 모아 dependency를 관리합니다.
final class AppDIContainer {
  private(set) var assembler: Assembler
  
  var resolver: Resolver {
    assembler.resolver
  }
  
  static var `default` = AppDIContainer()
  
  // MARK: - Lifecycle
  private init() {
    self.assembler = Assembler([
      CoreAssembly(),
      PersistentStorageAssembly(),
      RepositoryAssembly(),
      DomainAssembly(),
      PresentationAssembly(),
      FlowCoordinatorAssembly()])
  }
  
  func resolve<Service>(_: Service.Type, name: ServiceName?) -> Service? {
    return resolver.resolve(Service.self, name: name)
  }
}
