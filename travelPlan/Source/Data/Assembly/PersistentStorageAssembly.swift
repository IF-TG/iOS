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
    container.register(OwnerStorage.self) { _ in
      UserDefaultsOwnerStorage()
    }
    
    // TODO: - PersistentStorages LoginResponseStorage
    container.register(LoginResultStorage.self) { _ in
      UserDefaultsLoginResultStorage()
    }
  }
}
