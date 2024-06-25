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
    
    // MARK: - PostDetail Page
    // MARK: - PostDetailViewModelType
    container.register(
      PostDetailViewModelType.self,
      name: .implementation(.default)
    ) { (r, postId: PostIdentifier, post: Post?, actions: PostDetailViewModelActions) in
      let defaultPostFetchUseCase = r.resolve(PostFetchUseCase.self, name: .implementation(.default))!
      let defaultOwnerRepository = r.resolve(LoggedInUserRepository.self, name: .implementation(.default))!
      return PostDetailViewModel(
        post: post,
        postId: postId,
        postFetchUseCase: defaultPostFetchUseCase,
        ownerRepository: defaultOwnerRepository,
        actions: actions)
    }
    
    container.register(
      PostDetailViewModelType.self, name: .testDouble(.mock)
    ) { (r, postId: PostIdentifier, post: Post?, actions: PostDetailViewModelActions) in
      let mockPostFetchUseCase = r.resolve(PostFetchUseCase.self, name: .testDouble(.mock))!
      let stubOwnerRepository = r.resolve(LoggedInUserRepository.self, name: .testDouble(.stub))!
      return PostDetailViewModel(
        post: post,
        postId: postId,
        postFetchUseCase: mockPostFetchUseCase,
        ownerRepository: stubOwnerRepository,
        actions: actions)
    }
    
    // MARK: - PostDetailChatViewModelType
    container.register(PostDetailChatViewModelInfo.self) { (_, postId: PostIdentifier, post: Post?) in
      return PostDetailChatViewModelInfo(postId: postId, hasEnteredByDeferredDeepLink: post == nil)
    }.inObjectScope(.transient)
    
    container.register(
      PostDetailChatViewModelType.self, name: .implementation(.default)
    ) { (r, postId: PostIdentifier, post: Post?, actions: PostDetailChatViewModelActions) in
      let postDetailChatInfo = r.resolve(PostDetailChatViewModelInfo.self, arguments: postId, post)!
      let defaultPostCommentAndPostLitedStateFetchUseCase = r.resolve(
        DefaultPostCommentsAndPostLikeStateFetchUseCase.self, name: .implementation(.default))!
      let defaultPostCommentUseCase = r.resolve(PostCommentUseCase.self, name: .implementation(.default))!
      let defaultPostCommentHeartUseCase = r.resolve(PostCommentHeartUseCase.self, name: .implementation(.default))!
      let defaultPostNestedCommentUseCase = r.resolve(PostNestedCommentUseCase.self, name: .implementation(.default))!
      let defaultPostNestedCommentHeartUseCase = r.resolve(
        PostNestedCommentHeartUseCase.self, name: .implementation(.default))!
      let defaultUserBlockUseCase = r.resolve(UserBlockUseCase.self, name: .implementation(.default))!
      let defaultOwnerRepository = r.resolve(LoggedInUserRepository.self, name: .implementation(.default))!
      
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
    
    container.register(
      PostDetailChatViewModelType.self, name: .testDouble(.mock)
    ) { (r, postId: PostIdentifier, post: Post?, actions: PostDetailChatViewModelActions) in
      let postDetailChatInfo = r.resolve(PostDetailChatViewModelInfo.self, arguments: postId, post)!
      let interceptedPostCommentAndPostLitedStateFetchUseCase = r.resolve(
        DefaultPostCommentsAndPostLikeStateFetchUseCase.self, name: .implementation(.interceptedDefault))!
      let interceptedPostCommentUseCase = r.resolve(PostCommentUseCase.self, name: .implementation(.interceptedDefault))!
      let interceptedPostCommentHeartUseCase = r.resolve(
        PostCommentHeartUseCase.self, name: .implementation(.interceptedDefault))!
      let interceptedPostNestedCommentUseCase = r.resolve(
        PostNestedCommentUseCase.self, name: .implementation(.interceptedDefault))!
      let interceptedPostNestedCommentHeartUseCase = r.resolve(
        PostNestedCommentHeartUseCase.self, name: .implementation(.interceptedDefault))!
      let mockUserBlockUseCase = r.resolve(UserBlockUseCase.self, name: .testDouble(.mock))!
      let stubOwnerRepository = r.resolve(LoggedInUserRepository.self, name: .testDouble(.stub))!
      
      return PostDetailChatViewModel(
        postDetailChatInfo: postDetailChatInfo,
        postCommentsAndPostLikeStateFetchUseCase: interceptedPostCommentAndPostLitedStateFetchUseCase,
        postCommentUseCase: interceptedPostCommentUseCase,
        postCommentHeartUseCase: interceptedPostCommentHeartUseCase,
        postNestedCommentUseCase: interceptedPostNestedCommentUseCase,
        postNestedCommentHeartUseCase: interceptedPostNestedCommentHeartUseCase,
        userBlockUseCase: mockUserBlockUseCase,
        ownerRepository: stubOwnerRepository,
        actions: actions)
    }
    
    // MARK: - PostDetailViewController
    container.register(
      PostDetailViewController.self, name: .implementation(.default)
    ) { (r, coordinator: PostDetailCoordinator) in
      let mockPostDetailViewModel = r.resolve(PostDetailViewModelType.self, name: .testDouble(.mock))!
      let mockPostDetailChatViewModel = r.resolve(
        PostDetailChatViewModelType.self, name: .testDouble(.mock))!
      let mockPostOptionViewModel = r.resolve(PostOptionViewModelType.self, name: .testDouble(.mock))!
      coordinator.setPostReceivable(mockPostDetailViewModel)
      return PostDetailViewController(
        viewModel: mockPostDetailViewModel,
        chatViewModel: mockPostDetailChatViewModel,
        optionViewModel: mockPostOptionViewModel)
    }
    
    container.register(
      PostDetailViewController.self, name: .testDouble(.mock)
    ) { (r, coordinator: PostDetailCoordinator) in
      let defaultPostDetailViewModel = r.resolve(PostDetailViewModelType.self, name: .implementation(.default))!
      let defaultPostDetailChatViewModel = r.resolve(
        PostDetailChatViewModelType.self, name: .implementation(.default))!
      let postOptionViewModel = r.resolve(PostOptionViewModelType.self, name: .implementation(.default))!
      coordinator.setPostReceivable(defaultPostDetailViewModel)
      return PostDetailViewController(
        viewModel: defaultPostDetailViewModel,
        chatViewModel: defaultPostDetailChatViewModel,
        optionViewModel: postOptionViewModel)
    }
    
    // MARK: - Post OptionViewModel Type
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
