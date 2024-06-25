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
  // swiftlint:disable:next function_body_length
  func assemble(container: Swinject.Container) {
    // TODO: - Login Page
    container.register((any LoginViewModel).self) { r in
      let loginRepository = r.resolve(LoginRepository.self)!
      let loginUseCase = r.resolve(LoginUseCase.self)!
      return DefaultLoginViewModel(loginUseCase: loginUseCase)
    }
    
    container.register(LoginViewController.self) { r in
      let loginViewModel = r.resolve((any LoginViewModel).self)!
      return LoginViewController(viewModel: loginViewModel)
    }
    
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
    
    // MARK: - Notification Page
    typealias NoticeViewModelType = any NoticeViewModelable & NoticeViewAdapterDataSource
    typealias NotificationViewModelType = any NotificationViewModelable & NotificationViewAdapterDataSource
    
    // MARK: NotificationViewModelType
    container.register(NotificationViewModelType.self) { _ in
      return NotificationViewModel()
    }
    
    // MARK: NoticeViewModelType
    container.register(NoticeViewModelType.self, name: .implementation(.default)) { r in
      let defaultNoticeUseCase = r.resolve(NoticeUseCase.self, name: .implementation(.default))!
      return NoticeViewModel(noticeUseCase: defaultNoticeUseCase)
    }
    
    container.register(NoticeViewModelType.self, name: .implementation(.interceptedDefault)) { r in
      let interceptedNoticeUseCase = r.resolve(NoticeUseCase.self, name: .implementation(.interceptedDefault))!
      return NoticeViewModel(noticeUseCase: interceptedNoticeUseCase)
    }
    
    container.register(NoticeViewModelType.self, name: .implementation(.firestore)) { r in
      let firestoreNoticeUseCase = r.resolve(NoticeUseCase.self, name: .implementation(.firestore))!
      return NoticeViewModel(noticeUseCase: firestoreNoticeUseCase)
    }
    
    // MARK: NotificationCenterViewController
    container.register(NotificationCenterViewController.self, name: .implementation(.default)) { r in
      let defaultNotificationViewModel = r.resolve(NotificationViewModelType.self)!
      let defaultNoticeViewModel = r.resolve(NoticeViewModelType.self, name: .implementation(.default))!
      return NotificationCenterViewController(
        noticeViewModel: defaultNoticeViewModel,
        notificationViewModel: defaultNotificationViewModel)
    }
    
    container.register(NotificationCenterViewController.self, name: .implementation(.interceptedDefault)) { r in
      let defaultNotificationViewModel = r.resolve(NotificationViewModelType.self)!
      let interceptedNoticeViewModel = r.resolve(NoticeViewModelType.self, name: .implementation(.interceptedDefault))!
      return NotificationCenterViewController(
        noticeViewModel: interceptedNoticeViewModel,
        notificationViewModel: defaultNotificationViewModel)
    }
    
    container.register(NotificationCenterViewController.self, name: .implementation(.firestore)) { r in
      let defaultNotificationViewModel = r.resolve(NotificationViewModelType.self)!
      let firestoreNoticeViewModel = r.resolve(NoticeViewModelType.self, name: .implementation(.firestore))!
      return NotificationCenterViewController(
        noticeViewModel: firestoreNoticeViewModel,
        notificationViewModel: defaultNotificationViewModel)
    }

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
