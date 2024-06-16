//
//  PresentationAssembly.swift
//  travelPlan
//
//  Created by 양승현 on 6/5/24.
//

import UIKit
import SHCoordinator
import Swinject

final class PresentationAssembly: Assembly {
  func assemble(container: Swinject.Container) {
    // TODO: - Login Page
    
    // TODO: - PostDetail Page
    
    // TODO: - Post
    typealias PostOptionViewModelType = (any PostOptionViewModelable & PostOptionViewModelPageDelegate)
    
    container.register(
      PostOptionViewModelType.self,
      name: .implementation(.default)
    ) { (r, postOptionDataSource: PostOptionViewModelInfo, actions: PostOptionViewModelActions) in
      let defaultOwnerRepository = r.resolve(LoggedInUserRepository.self, name: .implementation(.default))!
      let defaultUserBlockUseCase = r.resolve(UserBlockUseCase.self, name: .implementation(.default))!
      
      return PostOptionViewModel(
        dataSource: postOptionDataSource,
        actions: actions,
        ownerRepository: defaultOwnerRepository,
        userBlockUseCase: defaultUserBlockUseCase)
    }.inObjectScope(.transient)
    
    container.register(
      PostOptionViewModelType.self,
      name: .implementation(.interceptedDefault)
    ) { (r, postOptionDataSource: PostOptionViewModelInfo, actions: PostOptionViewModelActions) in
      let stubOwnerRepository = r.resolve(LoggedInUserRepository.self, name: .testDouble(.stub))!
      let interceptedUserBlockUseCase = r.resolve(UserBlockUseCase.self, name: .implementation(.interceptedDefault))!
      
      return PostOptionViewModel(
        dataSource: postOptionDataSource,
        actions: actions,
        ownerRepository: stubOwnerRepository,
        userBlockUseCase: interceptedUserBlockUseCase)
    }.inObjectScope(.transient)
    
    container.register(
      PostOptionViewModelType.self,
      name: .testDouble(.mock)
    ) { (r, postOptionDataSource: PostOptionViewModelInfo, actions: PostOptionViewModelActions) in
      let stubOwnerRepository = r.resolve(LoggedInUserRepository.self, name: .testDouble(.stub))!
      let mockUserBlockUseCase = r.resolve(UserBlockUseCase.self, name: .testDouble(.mock))!
      
      return PostOptionViewModel(
        dataSource: postOptionDataSource,
        actions: actions,
        ownerRepository: stubOwnerRepository,
        userBlockUseCase: mockUserBlockUseCase)
    }.inObjectScope(.transient)
    
    container.register(
      PostOptionViewModelType.self,
      name: .implementation(.firestore)
    ) { (r, postOptionDataSource: PostOptionViewModelInfo, actions: PostOptionViewModelActions) in
      let defaultOwnerRepository = r.resolve(LoggedInUserRepository.self, name: .implementation(.default))!
      let firestoreUserBlockUseCase = r.resolve(UserBlockUseCase.self, name: .implementation(.firestore))!
      
      return PostOptionViewModel(
        dataSource: postOptionDataSource,
        actions: actions,
        ownerRepository: defaultOwnerRepository,
        userBlockUseCase: firestoreUserBlockUseCase)
    }.inObjectScope(.transient)
    
    // TODO: - Notification Page
    
    // TODO: - Album Page
    
    // TODO: - Main Page
    container.register(MainTabBarController.self) { _ in
      MainTabBarController()
    }
    
    // TODO: - Setting Page
    
    // TODO: - Favorite Page
    
    // TODO: - Search Page
    
    // TODO: - SearchDetail Page
    
    // TODO: - Plan Page
    
    // TODO: - ReviewWriting Page
  }
}
