//
//  PersistentStorageAssembly.swift
//  travelPlan
//
//  Created by 양승현 on 6/5/24.
//

import Foundation
import Swinject

final class PersistentStorageAssembly: Swinject.Assembly {
  func assemble(container: Swinject.Container) {
    // MARK: - PersistentStorages UserStorage
    container.register(OwnerStorage.self, name: .implementation(.default)) { _ in
      UserDefaultsOwnerStorage()
    }
    
    container.register(OwnerStorage.self, name: .testDouble(.stub)) { _ in
      StubOwnerStorage()
    }
    
    // TODO: - PersistentStorages LoginResponseStorage
    container.register(LoginResultStorage.self, name: .implementation(.default)) { _ in
      UserDefaultsLoginResultStorage()
    }
  }
}
