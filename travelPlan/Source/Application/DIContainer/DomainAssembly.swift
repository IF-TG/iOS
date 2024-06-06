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
