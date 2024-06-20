//
//  Dependency.swift
//  travelPlan
//
//  Created by 양승현 on 6/4/24.
//

import Foundation
import Swinject

/// Swinject에서 resolve를 쉽게 해결해주는 Property wrapper 입니다.
///
/// Notes:
/// - @Dependency 어노테이션을 표기할 경우 `name` 을 외부에서 지정해야할 때,
///     해당 프로퍼티를 소유한 객체의 init시점에 name을 받아 초기화 해야 함으로  두 번 초기화가 되게 됩니다.
///   - 아래 예시 코드로 해결할 수 있습니다.
/// - 장점: resolve 호출을 wrapping해줍니다.
/// - 단점: 기존 방식은 Service를 등록할 때 등록시점에 factory를 통해 모든 의존성을 resolve합니다. property Wrapper는 단순해져서 해당 구체Service타입 통해 확인해야합니다.
/// ```
/// /// Declare
/// class UseCase {
///   // MARK: -
///   // @Dependency var repository: Repository [ x ]
///   var repository: Dependency<Repository>
///
///   init(repository: Dependency<Repository>) {
///     self.repository = repository
///   }
/// }
///
/// /// Usage
/// // 주의할 점은 .init 으로 propertyWrapper를 초기화 할 경우 컴파일러가 추론을 못 할수도 있어서 명확하게 Dependency(...) 호출해야 합니다.
///  let useCase = UseCase(repository: Dependency(name: .implement(.default)))
/// ```
@propertyWrapper
final class Dependency<Value> {
  // MARK: - Properties
  private var value: Value?
  private let assembler: Assembler
  /// 컨테이너에 register할 때 resolver가 필요한 경우 지정하면 DI graph 형성시 이를 통해 가져옵니다.
  private let resolver: Resolver?
  private let name: ServiceName?
  
  // MARK: - Lifecycle
  init(
    value: Value? = nil,
    resolver: Resolver? = nil,
    assembler: Assembler = AppDIContainer.shared.assembler,
    name: ServiceName? = nil
  ) {
    self.value = value
    self.resolver = resolver
    self.assembler = assembler
    self.name = name
  }
  
  // MARK: - Wrapped
  var wrappedValue: Value {
    get {
      if let value {
        return value
      }
      
      if let resolver = resolver, let value: Value = resolver.resolve(Value.self, name: name) {
        self.value = value
        return value
      }
      
      /// ServiceKey로 이름을 지정한 경우
      if let value: Value = assembler.resolver.resolve(Value.self, name: name) {
        self.value = value
        return value
      }
      fatalError("\(Value.self)를 resolve할 수 없습니다. 사전에 등록해야 합니다.")
    } set {
      value = newValue
    }
  }
}
