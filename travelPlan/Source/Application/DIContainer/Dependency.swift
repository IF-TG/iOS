//
//  Dependency.swift
//  travelPlan
//
//  Created by 양승현 on 6/4/24.
//

import Foundation
import Swinject

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
    self.init(engine: YeoGaAssembler.default.assembler,name: name)
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
