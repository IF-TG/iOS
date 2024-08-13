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
    searchPage(container: container)
    searchResultListPage(container: container)
    searchHistoryPage(container: container)
    destinationDetailPage(container: container)
    
    // MARK: - Search Page
    
    // MARK: - PostDetail Page
    // MARK: - PostDetailViewModelType
    container.register(
      PostDetailViewModelType.self
    ) { (r, postId: PostIdentifier, post: Post?, actions: PostDetailViewModelActions) in
      let defaultPostFetchUseCase = r.resolve(PostFetchUseCase.self)!
      let defaultPostHeartUseCase = r.resolve(PostHeartUseCase.self)!
      let ownerRepository = self.ownerRepository(with: r)
      return PostDetailViewModel(
        post: post,
        postId: postId,
        postFetchUseCase: defaultPostFetchUseCase, 
        postHeartUseCase: defaultPostHeartUseCase,
        ownerRepository: ownerRepository,
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
      let ownerRepository = self.ownerRepository(with: r)
      
      return PostDetailChatViewModel(
        postDetailChatInfo: postDetailChatInfo,
        postCommentsAndPostLikeStateFetchUseCase: defaultPostCommentAndPostLitedStateFetchUseCase,
        postCommentUseCase: defaultPostCommentUseCase,
        postCommentHeartUseCase: defaultPostCommentHeartUseCase,
        postNestedCommentUseCase: defaultPostNestedCommentUseCase,
        postNestedCommentHeartUseCase: defaultPostNestedCommentHeartUseCase,
        userBlockUseCase: defaultUserBlockUseCase,
        ownerRepository: ownerRepository,
        actions: actions)
    }
    
    // MARK: - PostDetailViewController
    container.register(
      PostDetailViewController.self
    ) { (r, coordinator: PostDetailCoordinator, postId: PostIdentifier, post: Post?) in
      let postDetailViewModel = r.resolve(
        PostDetailViewModelType.self,
        arguments: postId, post, coordinator.makePostDetailViewModelActions())!
      let postDetailChatViewModel = r.resolve(
        PostDetailChatViewModelType.self,
        arguments: postId, post, coordinator.makePostDetailChatViewModelActions())!
      let postOptionViewModel = r.resolve(
        PostOptionViewModelType.self,
        arguments:
          coordinator.makePostOptionViewModelInfo(postId: postId, post: post),
        coordinator.makePostOptionViewModelActions())!
      coordinator.setPostReceivable(postDetailViewModel)
      return PostDetailViewController(
        viewModel: postDetailViewModel,
        chatViewModel: postDetailChatViewModel,
        optionViewModel: postOptionViewModel)
    }
    
    // MARK: - Post OptionViewModel Type
    container.register(
      PostOptionViewModelType.self
    ) { (r, postOptionDataSource: PostOptionViewModelInfo, actions: PostOptionViewModelActions) in
      let ownerRepository = self.ownerRepository(with: r)
      let defaultUserBlockUseCase = r.resolve(UserBlockUseCase.self)!
      
      return PostOptionViewModel(
        dataSource: postOptionDataSource,
        actions: actions,
        ownerRepository: ownerRepository,
        userBlockUseCase: defaultUserBlockUseCase)
    }.inObjectScope(.transient)
    
    container.register(
      PostOptionViewModelType.self,
      name: .firebase
    ) { (r, postOptionDataSource: PostOptionViewModelInfo, actions: PostOptionViewModelActions) in
      let ownerRepository = self.ownerRepository(with: r)
      let firestoreUserBlockUseCase = r.resolve(UserBlockUseCase.self, name: .firebase)!
      
      return PostOptionViewModel(
        dataSource: postOptionDataSource,
        actions: actions,
        ownerRepository: ownerRepository,
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
    
    // TODO: - Plan Page
    
    // TODO: - ReviewWriting Page
  }
}

// MARK: - Private Helpers
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
  
  func searchPage(container: Container) {
    container.register(SearchViewController.self) { (r, actions: SearchViewModelActions) in
      let searchViewModel = r.resolve((any SearchViewModel).self, argument: actions)!
      return SearchViewController(viewModel: searchViewModel)
    }
    
    container.register((any SearchViewModel).self) { (r, actions: SearchViewModelActions) in
      let useCase = r.resolve(DestinationRecommendUseCase.self)!
      return DefaultSearchViewModel(useCase: useCase, actions: actions)
    }
  }
  
  func ownerRepository(with r: Resolver) -> any LoggedInUserRepository {
#if DEBUG
    return DefaultLoggedInUserRepository(storage: .init(value: StubOwnerStorage()))
#else
    return r.resolve(LoggedInUserRepository.self)!
#endif
  }
    
  func searchResultListPage(container: Container) {
    container.register((any SearchResultListViewModel).self) { 
      (r, actions: SearchResultListViewModelActions, searchKeyword: String) in
      let useCase = r.resolve(DestinationSearchResultUseCase.self)!
      
      return DefaultSearchResultListViewModel(
        actions: actions,
        searchKeyword: searchKeyword,
        useCase: useCase
      )
    }
    
    container.register(SearchResultListViewController.self) {
      (r, actions: SearchResultListViewModelActions, searchKeyword: String) in
      let viewModel = r.resolve((any SearchResultListViewModel).self, arguments: actions, searchKeyword)!
      return SearchResultListViewController(viewModel: viewModel)
    }
  }
  
  func searchHistoryPage(container: Container) {
    container.register((any SearchHistoryViewModel).self) { 
      (r, actions: SearchHistoryViewModelActions, searchType: SearchType) in
      let useCase = r.resolve(SearchHistoryUseCase.self)!

      return DefaultSearchHistoryViewModel(
        searchType: searchType,
        actions: actions,
        useCase: useCase
      )
    }
    
    container.register(SearchHistoryViewController.self) { 
      (r, actions: SearchHistoryViewModelActions, searchType: SearchType) in
      let viewModel = r.resolve((any SearchHistoryViewModel).self, arguments: actions, searchType)!
      return SearchHistoryViewController(viewModel: viewModel)
    }
  }
  
  func destinationDetailPage(container: Container) {
    container.register((any DestinationDetailViewModel).self) { (r, destinationId: DestinationIdEntity) in
      let destinationDetailUseCase = r.resolve(DestinationDetailUseCase.self)!
      return DefaultDestinationDetailViewModel(useCase: destinationDetailUseCase, destinationId: destinationId)
    }
    
    container.register(DestinationDetailViewController.self) 
    { (r, destinationId: DestinationIdEntity) in
      let viewModel = r.resolve((any DestinationDetailViewModel).self, argument: destinationId)!
      return DestinationDetailViewController(viewModel: viewModel)
    }
  }
}
