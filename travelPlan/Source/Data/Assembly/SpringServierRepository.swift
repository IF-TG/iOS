//
//  SpringServierRepository.swift
//  travelPlan
//
//  Created by 양승현 on 6/12/24.
//

import Swinject
import Foundation

final class SpringServierRepository: Assembly {
  func assemble(container: Swinject.Container) {
    // TODO: - SpringServer
    
    // TODO: - SpringServer User
    container.register(LoggedInUserRepository.self, name: .implementation(.default)) { _ in
      return DefaultLoggedInUserRepository(storage: Dependency(name: .implementation(.default)))
    }
    
    container.register(LoggedInUserRepository.self, name: .testDouble(.stub)) { _ in
      return DefaultLoggedInUserRepository(storage: Dependency(name: .testDouble(.stub)))
    }
    
    // TODO: - SpringServer Post
    container.register(PostRepository.self, name: .implementation(.default)) { r in
      let defaultOwnerStorage = r.resolve(OwnerStorage.self, name: .implementation(.default))!
      let defaultSessionProvider = r.resolve(Sessionable.self, name: .implementation(.default))!
      return DefaultPostRepository(service: defaultSessionProvider, ownerStorage: defaultOwnerStorage)
    }
    
    container.register(PostRepository.self, name: .implementation(.interceptedDefault)) { r in
      let stubOwnerStorage = r.resolve(OwnerStorage.self, name: .testDouble(.stub))!
      let mockSessionProvider = r.resolve(Sessionable.self, name: .testDouble(.mock))!
      return DefaultPostRepository(service: mockSessionProvider, ownerStorage: stubOwnerStorage)
    }
  }
}
