//
//  DomainAssembly.swift
//  travelPlan
//
//  Created by 양승현 on 6/5/24.
//

import Foundation
import Swinject

final class DomainAssembly: Swinject.Assembly {
  func assemble(container: Container) {
    // TODO: - Tour Use Case
    
    // TODO: - User Use Case
    container.register(UserBlockUseCase.self, name: .implementation(.default)) { r in
      let defaultUserBlockRepository = r.resolve(UserBlockRepository.self, name: .implementation(.default))!
      return DefaultUserBlockUseCase(userBlockRepository: defaultUserBlockRepository)
    }
    
    container.register(UserBlockUseCase.self, name: .implementation(.firestore)) { r in
      let firestoreUserBlockRepository = r.resolve(UserBlockRepository.self, name: .implementation(.firestore))!
      return DefaultUserBlockUseCase(userBlockRepository: firestoreUserBlockRepository)
    }
    
    container.register(UserBlockUseCase.self, name: .implementation(.interceptedDefault)) { r in
      let interceptedUserBlockRepository = r.resolve(
        UserBlockRepository.self,
        name: .implementation(.interceptedDefault))!
      return DefaultUserBlockUseCase(userBlockRepository: interceptedUserBlockRepository)
    }
    
    // TODO: - Album Use Case
    
    // TODO: - Post Use Case
    container.register(PostFetchUseCase.self, name: .implementation(.default)) { r in
      let defaultPostRepository = r.resolve(PostRepository.self, name: .implementation(.default))!
      return DefaultPostFetchUseCase(postRepository: defaultPostRepository)
    }.inObjectScope(.transient)
    
    container.register(PostFetchUseCase.self, name: .implementation(.interceptedDefault)) { r in
      let interceptedPostRepository = r.resolve(PostRepository.self, name: .implementation(.interceptedDefault))!
      return DefaultPostFetchUseCase(postRepository: interceptedPostRepository)
    }.inObjectScope(.transient)
    
    container.register(PostFetchUseCase.self, name: .testDouble(.mock)) { _ in
      MockPostFetchUseCase()
    }.inObjectScope(.transient)
    
    // TODO: - PostReviewWriting Use Case
    
    // TODO: - PostComment Use Case
    
    // TODO: - PostNestedComment Use Case
    
    // TODO: - FavoriteDirectory Use Case
    
    // TODO: - Authentication Use Case
  }
}
