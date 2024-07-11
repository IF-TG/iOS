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
    loginPage(container: container)
    
    // MARK: - PostDetail Page
    // MARK: - PostDetailViewModelType
    container.register(
      PostDetailViewModelType.self
    ) { (r, postId: PostIdentifier, post: Post?, actions: PostDetailViewModelActions) in
      let defaultPostFetchUseCase = r.resolve(PostFetchUseCase.self)!
      let defaultOwnerRepository = r.resolve(LoggedInUserRepository.self)!
      return PostDetailViewModel(
        post: post,
        postId: postId,
        postFetchUseCase: defaultPostFetchUseCase,
        ownerRepository: defaultOwnerRepository,
        actions: actions)
    }
    
    // MARK: - PostDetailChatViewModelType
    container.register(PostDetailChatViewModelInfo.self) { (_, postId: PostIdentifier, post: Post?) in
      return PostDetailChatViewModelInfo(postId: postId, hasEnteredByDeferredDeepLink: post == nil)
    }.inObjectScope(.transient)
    
    container.register(
      PostDetailChatViewModelType.self
    ) { (r, postId: PostIdentifier, post: Post?, actions: PostDetailChatViewModelActions) in
      let postDetailChatInfo = r.resolve(PostDetailChatViewModelInfo.self, arguments: postId, post)!
      let defaultPostCommentAndPostLitedStateFetchUseCase = r.resolve(
        PostCommentsAndPostLikeStateFetchUseCase.self)!
      let defaultPostCommentUseCase = r.resolve(PostCommentUseCase.self)!
      let defaultPostCommentHeartUseCase = r.resolve(PostCommentHeartUseCase.self)!
      let defaultPostNestedCommentUseCase = r.resolve(PostNestedCommentUseCase.self)!
      let defaultPostNestedCommentHeartUseCase = r.resolve(
        PostNestedCommentHeartUseCase.self)!
      let defaultUserBlockUseCase = r.resolve(UserBlockUseCase.self)!
      let defaultOwnerRepository = r.resolve(LoggedInUserRepository.self)!
      
      return PostDetailChatViewModel(
        postDetailChatInfo: postDetailChatInfo,
        postCommentsAndPostLikeStateFetchUseCase: defaultPostCommentAndPostLitedStateFetchUseCase,
        postCommentUseCase: defaultPostCommentUseCase,
        postCommentHeartUseCase: defaultPostCommentHeartUseCase,
        postNestedCommentUseCase: defaultPostNestedCommentUseCase,
        postNestedCommentHeartUseCase: defaultPostNestedCommentHeartUseCase,
        userBlockUseCase: defaultUserBlockUseCase,
        ownerRepository: defaultOwnerRepository,
        actions: actions)
    }
        
    // MARK: - PostDetailViewController
    container.register(
      PostDetailViewController.self
    ) { (r, coordinator: PostDetailCoordinator, postId: PostIdentifier, post: Post?) in
      let mockPostDetailViewModel = r.resolve(
        PostDetailViewModelType.self,
        arguments: postId, post, coordinator.makePostDetailViewModelActions())!
      let mockPostDetailChatViewModel = r.resolve(
        PostDetailChatViewModelType.self,
        arguments: postId, post, coordinator.makePostDetailChatViewModelActions())!
      let mockPostOptionViewModel = r.resolve(
        PostOptionViewModelType.self,
        arguments:
          coordinator.makePostOptionViewModelInfo(postId: postId, post: post),
          coordinator.makePostOptionViewModelActions())!
      coordinator.setPostReceivable(mockPostDetailViewModel)
      return PostDetailViewController(
        viewModel: mockPostDetailViewModel,
        chatViewModel: mockPostDetailChatViewModel,
        optionViewModel: mockPostOptionViewModel)
    }
    
    // MARK: - Post OptionViewModel Type
    container.register(
      PostOptionViewModelType.self
    ) { (r, postOptionDataSource: PostOptionViewModelInfo, actions: PostOptionViewModelActions) in
      let defaultOwnerRepository = r.resolve(LoggedInUserRepository.self)!
      let defaultUserBlockUseCase = r.resolve(UserBlockUseCase.self)!
      
      return PostOptionViewModel(
        dataSource: postOptionDataSource,
        actions: actions,
        ownerRepository: defaultOwnerRepository,
        userBlockUseCase: defaultUserBlockUseCase)
    }.inObjectScope(.transient)
    
    container.register(
      PostOptionViewModelType.self,
      name: .firebase
    ) { (r, postOptionDataSource: PostOptionViewModelInfo, actions: PostOptionViewModelActions) in
      let defaultOwnerRepository = r.resolve(LoggedInUserRepository.self)!
      let firestoreUserBlockUseCase = r.resolve(UserBlockUseCase.self, name: .firebase)!
      
      return PostOptionViewModel(
        dataSource: postOptionDataSource,
        actions: actions,
        ownerRepository: defaultOwnerRepository,
        userBlockUseCase: firestoreUserBlockUseCase)
    }.inObjectScope(.transient)
    
    // MARK: - PostDetailCategoryViewController
    container.register(PostDetailCategoryViewController.self) { (_, dataSource: [String]) in
      return PostDetailCategoryViewController(style: .plain, dataSource: dataSource)
    }
    
    // MARK: - Notification Page
    typealias NoticeViewModelType = any NoticeViewModelable & NoticeViewAdapterDataSource
    typealias NotificationViewModelType = any NotificationViewModelable & NotificationViewAdapterDataSource
    
    // MARK: NotificationViewModelType
    container.register(NotificationViewModelType.self) { _ in
      return NotificationViewModel()
    }
    
    // MARK: NoticeViewModelType
    container.register(NoticeViewModelType.self) { r in
      let defaultNoticeUseCase = r.resolve(NoticeUseCase.self)!
      return NoticeViewModel(noticeUseCase: defaultNoticeUseCase)
    }
    
    container.register(NoticeViewModelType.self, name: .firebase) { r in
      let firestoreNoticeUseCase = r.resolve(NoticeUseCase.self, name: .firebase)!
      return NoticeViewModel(noticeUseCase: firestoreNoticeUseCase)
    }
    
    // MARK: NotificationCenterViewController
    container.register(NotificationCenterViewController.self) { r in
      let defaultNotificationViewModel = r.resolve(NotificationViewModelType.self)!
      let defaultNoticeViewModel = r.resolve(NoticeViewModelType.self)!
      return NotificationCenterViewController(
        noticeViewModel: defaultNoticeViewModel,
        notificationViewModel: defaultNotificationViewModel)
    }
    
    container.register(NotificationCenterViewController.self, name: .firebase) { r in
      let defaultNotificationViewModel = r.resolve(NotificationViewModelType.self)!
      let firestoreNoticeViewModel = r.resolve(NoticeViewModelType.self, name: .firebase)!
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

// MARK: - Login Page
private extension PresentationAssembly {
  func loginPage(container: Container) {
    container.register((any LoginViewModel).self) { r in
      let loginUseCase = r.resolve(LoginUseCase.self)!
      return DefaultLoginViewModel(loginUseCase: loginUseCase)
    }
    
    container.register(LoginViewController.self) { r in
      let loginViewModel = r.resolve((any LoginViewModel).self)!
      return LoginViewController(viewModel: loginViewModel)
    }
  }
}
