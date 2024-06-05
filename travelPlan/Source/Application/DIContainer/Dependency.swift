//
//  Dependency.swift
//  travelPlan
//
//  Created by 양승현 on 6/4/24.
//

import Foundation
import Swinject

/// 실험중인 객체입니다.
/// 원래 dependency를 등록할때 Assembly에서 등록하기에 아직까지 이 Wrapper 객체를 사용한다고 이점이 없는것 같습니다.
/// Dependency를 container에 register할 때 protocol인 경우 Mock, Stub, Default etc... 의존성이 등록되고 name으로 가져와야하지만,
/// @Dependency 프로퍼티를 다시 init시점에 초기화할 때 두번 초기화가 되게 됩니다.
@propertyWrapper
final class Dependency<Value> {
  // MARK: - Properties
  private var value: Value?
  private let engine: Assembler
  private let name: ServiceName?
  
  // MARK: - Lifecycle
  init(value: Value? = nil, engine: Assembler, name: ServiceName? = nil) {
    self.value = value
    self.engine = engine
    self.name = name
  }
  
  convenience init(name: ServiceName? = nil) {
    self.init(engine: AppDIContainer.shared.assembler, name: name)
  }
  
  // MARK: - Wrapped
  var wrappedValue: Value {
    get {
      if let value {
        return value
      }
      if let value: Value = engine.resolver.resolve(Value.self, name: name) {
        self.value = value
        return value
      }
      fatalError("\(Value.self)를 resolve할 수 없습니다. 사전에 등록해야 합니다.")
    } set {
      value = newValue
    }
  }
}
