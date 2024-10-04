//
//  PresentationAssembly.swift
//  travelPlan
//
//  Created by 양승현 on 6/5/24.
//

import UIKit
import SHCoordinator
import Swinject
import Combine
import Photos

final class PresentationAssembly: Assembly {
  // swiftlint:disable:next function_body_length
  func assemble(container: Swinject.Container) {
    loginPage(container: container)
    searchPage(container: container)
    searchResultListPage(container: container)
    searchHistoryPage(container: container)
    destinationDetailPage(container: container)
    searchMoreDetailPage(container: container)
    reviewWritingPage(container: container)
    photoService(container: container)
    albumPhotoDetailPage(container: container)
    albumPage(container: container)
    
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
    
    // TODO: - Main Page
    container.register(MainTabBarController.self) { _ in
      MainTabBarController()
    }
    
    // MARK: - Setting Page
    container.register(SettingViewModelType.self) { (r, actions: SettingViewModelActions) in
      let ownerRepository = self.ownerRepository(with: r)
      return SettingViewModel(ownerRepository: ownerRepository, actions: actions)
    }
    
    container.register(SettingViewController.self) { (r, actions: SettingViewModelActions) in
      let settingViewModel = r.resolve(SettingViewModelType.self, argument: actions)!
      return SettingViewController(viewModel: settingViewModel)
    }
    
    container.register(OperationGuideViewController.self) { _ in
      return OperationGuideViewController(navigationTitle: "이용안내")
    }
    
    container.register(CustomerServiceViewController.self) { _ in
      return CustomerServiceViewController(navigationTitle: "고객센터")
    }
    
    container.register(MyInformationViewModelType.self) { (r, actions: MyInformationViewModelActions) in
      let userNicknameSettingUseCase = r.resolve(UserNicknameSettingUseCase.self)!
      let userProfileImageSettingUsecase = r.resolve(UserProfileImageSettingUseCase.self)!
      let nicknameValidationUseCase = r.resolve(NicknameValidationUseCase.self)!
      let ownerRepository = self.ownerRepository(with: r)
      
      return MyInformationViewModel(
        userNicknameSettingUseCase: userNicknameSettingUseCase,
        userProfileImageSettingUseCase: userProfileImageSettingUsecase,
        nicknameValidationUseCase: nicknameValidationUseCase,
        ownerRepository: ownerRepository,
        actions: actions)
    }
    
    container.register(MyInformationViewController.self) { (r, actions: MyInformationViewModelActions) in
      let viewModel = r.resolve(MyInformationViewModelType.self, argument: actions)!
      return MyInformationViewController(viewModel: viewModel)
    }
    
    container.register(MyInformationAlbumSheetViewController.self) { _ in
      MyInformationAlbumSheetViewController()
    }
    
    // TODO: - Favorite Page
    
    // TODO: - Plan Page
    
  }
}

// MARK: - Private Helpers
private extension PresentationAssembly {
  func loginPage(container: Container) {
    container.register((any LoginViewModel).self) { (r, actions: LoginViewModelActions) in
      let loginUseCase = r.resolve(LoginUseCase.self)!
      return DefaultLoginViewModel(loginUseCase: loginUseCase, actions: actions)
    }
    
    container.register(LoginViewController.self) { (r, actions: LoginViewModelActions) in
      let loginViewModel = r.resolve((any LoginViewModel).self, argument: actions)!
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
    container.register((any SearchResultListViewModel).self) { (r, actions: SearchResultListViewModelActions, searchKeyword: String) in
      let useCase = r.resolve(DestinationSearchResultUseCase.self)!
      
      return DefaultSearchResultListViewModel(
        actions: actions,
        searchKeyword: searchKeyword,
        useCase: useCase
      )
    }
    
    container.register(SearchResultListViewController.self) { (r, actions: SearchResultListViewModelActions, searchKeyword: String) in
      let viewModel = r.resolve((any SearchResultListViewModel).self, arguments: actions, searchKeyword)!
      return SearchResultListViewController(viewModel: viewModel)
    }
  }
  
  func searchHistoryPage(container: Container) {
    container.register((any SearchHistoryViewModel).self) { (r, actions: SearchHistoryViewModelActions, searchType: SearchType) in
      let useCase = r.resolve(SearchHistoryUseCase.self)!
      
      return DefaultSearchHistoryViewModel(
        searchType: searchType,
        actions: actions,
        useCase: useCase
      )
    }
    
    container.register(SearchHistoryViewController.self) { (r, actions: SearchHistoryViewModelActions, searchType: SearchType) in
      let viewModel = r.resolve((any SearchHistoryViewModel).self, arguments: actions, searchType)!
      return SearchHistoryViewController(viewModel: viewModel)
    }
  }
  
  func destinationDetailPage(container: Container) {
    container.register((any DestinationDetailViewModel).self)
    { (r, destinationId: DestinationIdEntity, actions: DestinationDetailViewModelActions) in
      let destinationDetailUseCase = r.resolve(DestinationDetailUseCase.self)!
      return DefaultDestinationDetailViewModel(
        useCase: destinationDetailUseCase,
        destinationId: destinationId,
        actions: actions
      )
    }
    
    container.register(DestinationDetailViewController.self) { (r, destinationId: DestinationIdEntity, actions: DestinationDetailViewModelActions) in
      let viewModel = r.resolve((any DestinationDetailViewModel).self, arguments: destinationId, actions)!
      return DestinationDetailViewController(viewModel: viewModel)
    }
  }
  
  func searchMoreDetailPage(container: Container) {
    container.register((any SearchMoreDetailViewModel).self) { (r, actions: SearchMoreDetailViewModelActions, destinationInfos: [TravelDestinationInfo], title: String, searchSection: SearchSectionIndex) in
      let scrapRepository: any DestinationScrapRepository
#if DEBUG
      scrapRepository = JsonMockDestinationScrapRepository()
#else
      scrapRepository = r.resolve(DestinationScrapRepository.self)!
#endif
      return DefaultSearchMoreDetailViewModel(
        actions: actions,
        destinations: destinationInfos,
        title: title,
        scrapRepository: scrapRepository,
        searchSection: searchSection
      )
    }
    
    container.register(SearchMoreDetailViewController.self) { (r, actions: SearchMoreDetailViewModelActions, destinationInfos: [TravelDestinationInfo], headerTitle: String, searchSection: SearchSectionIndex) in
      let viewModel = r.resolve(
        (any SearchMoreDetailViewModel).self,
        arguments: actions, destinationInfos, headerTitle, searchSection
      )!
      return SearchMoreDetailViewController(viewModel: viewModel)
    }
  }
  
  func reviewWritingPage(container: Container) {
    container.register((any ReviewWritingViewModel).self) { (r, mode, actions, selectedAssetsPublisher, selectedCategoryPublisher) in
      let reviewWritingUseCase = r.resolve(ReviewWritingUseCase.self)!
      let loggedInUserUseCase = r.resolve(LoggedInUserUseCase.self)!
      
      return DefaultReviewWritingViewModel(
        reviewWritingUseCase: reviewWritingUseCase,
        loggedInOwnerUseCase: loggedInUserUseCase,
        mode: mode,
        actions: actions,
        selectedAssetsPublisher: selectedAssetsPublisher,
        selectedCategoryPublisher: selectedCategoryPublisher
      )
    }
    
    container.register(ReviewWritingViewController.self) { (r, mode: ReviewWritingMode, actions: ReviewWritingViewModelActions, selectedAssetsPublisher: AnyPublisher<[PHAsset], Never>, selectedCategoryPublisher: AnyPublisher<Post.Category?, Never>) in
      let viewModel = r.resolve(
        (any ReviewWritingViewModel).self,
        arguments: mode, actions, selectedAssetsPublisher, selectedCategoryPublisher
      )!
      let photoService = r.resolve(PhotoService.self)!
      
      return ReviewWritingViewController(viewModel: viewModel, photoService: photoService)
    }
  }
  
  func photoService(container: Container) {
    container.register(PhotoService.self) { _ in
      return DefaultPhotoService()
    }
  }
  
  func albumPhotoDetailPage(container: Container) {
    container.register((any AlbumPhotoDetailViewModel).self) { (_, photoDetailModel, maxSelectPhotoCount, actions) in
      return DefaultAlbumPhotoDetailViewModel(
        dataSource: photoDetailModel,
        maxSelectPhotoCount: maxSelectPhotoCount,
        actions: actions
      )
    }
    
    container.register(AlbumPhotoDetailViewController.self) { (r, photoDetailModel: PhotoDetailModel, albumPhotoDetailPage: Int, actions: AlbumPhotoDetailViewModelActions) in
      let viewModel = r.resolve(
        (any AlbumPhotoDetailViewModel).self,
        arguments: photoDetailModel, albumPhotoDetailPage, actions
      )!
      let photoService = r.resolve(PhotoService.self)!
      return AlbumPhotoDetailViewController(viewModel: viewModel, photoService: photoService)
    }
  }
  
  func albumPage(container: Container) {
    container.register((any AlbumViewModel).self) { (r, parentPopPublisher: AnyPublisher<Void, Never>, actions: AlbumViewModelActions) in
      let albumUseCase = r.resolve(AlbumUseCase.self)!
      return DefaultAlbumViewModel(
        albumUseCase: albumUseCase,
        parentPopPublisher: parentPopPublisher,
        actions: actions
      )
    }
    
    container.register(AlbumViewController.self) { (r, parentPopPublisher: AnyPublisher<Void, Never>, actions: AlbumViewModelActions) in
      let viewModel = r.resolve((any AlbumViewModel).self, arguments: parentPopPublisher, actions)!
      let photoService = r.resolve(PhotoService.self)!
      return AlbumViewController(viewModel: viewModel, photoService: photoService)
    }
  }
}
