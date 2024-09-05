//
//  AppDIContainer.swift
//  travelPlan
//
//  Created by 양승현 on 6/4/24.
//

import UIKit
import Swinject
import SHCoordinator
import Combine
import Photos

/// Assembler는 단 하나의 인스턴스만 생겨야 합니다. 또한 앱이 종료되기 전까지 메모리에 로드되어 있음이 보장되야 합니다.
/// Yeoga앱이 실행되기 위해 필요로되는 Layer별 assembly들을 한 곳에 모아 dependency를 관리합니다.
final class AppDIContainer {
  private(set) var assembler: Assembler
  
  private(set) var container: Swinject.Container
  
  var resolver: Resolver {
    assembler.resolver
  }
  
  static var shared = AppDIContainer()
  
  // MARK: - Lifecycle
  private init() {
    self.container = Container()
    self.assembler = Assembler([], container: container)
    assembler.apply(assemblies: [
      CoreAssembly(),
      PersistentStorageAssembly(),
      TourRepositoryAssembly(),
      SpringServerRepositoryAssembly(),
      FirebaseRepositoryAssembly(),
      DomainAssembly(),
      PresentationFeedAssembly(),
      PresentationAssembly()])
  }
  
  func lazyApplyAssemblies() {
    assembler.apply(assembly: FlowCoordinatorAssembly())
  }
}

// MARK: - AppCoordinatorDependencies
extension AppDIContainer: AppCoordinatorDependencies {
  func makeLoginOwnerRepository() -> any LoggedInUserRepository {
    #if DEBUG
    let stubOwnerStorage = StubOwnerStorage()
    return DefaultLoggedInUserRepository(storage: .init(value: stubOwnerStorage))
    #else
    return resolve(LoggedInUserRepository.self)!
    #endif
  }
  
  func makeMainCoordinator() -> MainCoordinator {
    return resolve(MainCoordinator.self)!
  }
  
  func makeLoginCoordinator() -> LoginCoordinator {
    return resolve(LoginCoordinator.self)!
  }
}

// MARK: - MainCoordinatorDependencies
extension AppDIContainer: MainCoordinatorDependencies {
  func makeFeedCoordinator(presenter: UINavigationController) -> FeedCoordinator {
    return resolve(FeedCoordinator.self, argument: presenter)!
  }
  
  func makeSearchCoordinator(presenter: UINavigationController?) -> SearchCoordinator {
    return resolve(SearchCoordinator.self, argument: presenter)!
  }
  
  func makePlanCoordinator(presenter: UINavigationController) -> PlanCoordinator {
    return resolve(PlanCoordinator.self, argument: presenter)!
  }
  
  func makeFavoriteCoordinator(presenter: UINavigationController) -> FavoriteCoordinator {
    return resolve(FavoriteCoordinator.self, argument: presenter)!
  }
  
  func makeSettingCoordinator(presenter: UINavigationController) -> SettingCoordinator {
    return resolve(SettingCoordinator.self, argument: presenter)!
  }
}

// MARK: - FeedCoordinatorDependencies
extension AppDIContainer: FeedCoordinatorDependencies {
  func makeFeedViewController(with coordinator: FeedCoordinator) -> FeedViewController {
    return resolver.resolve(FeedViewController.self, argument: coordinator)!
  }
  
  func makePostDetailCoordinator(
    presenter: UINavigationController?,
    post: Post?,
    postId: PostIdentifier
  ) -> PostDetailCoordinator {
    return resolver.resolve(PostDetailCoordinator.self, arguments: presenter, post, postId)!
  }
  
  func makeNotificationCoordinator(
    presenter: UINavigationController?
  ) -> NotificationCenterCoordinator {
    return resolver.resolve(NotificationCenterCoordinator.self, argument: presenter)!
  }
  
  func makeReviewWritingCoordinator(
    presenter: UINavigationController?,
    mode: ReviewWritingMode
  ) -> ReviewWritingCoordinator {
    return resolver.resolve(ReviewWritingCoordinator.self, arguments: presenter, mode)!
  }
}

// MARK: - NotificationCenterCoordinatorDependencies
extension AppDIContainer: NotificationCenterCoordinatorDependencies {
  /// 업데이트마다 보여지는 공지사항은  spring server를 활용한 레포를 구현했지만, 해당 기능 제공이 불확실해서
  ///   Firestore로도 구현했습니다. firestore에서 로그인하지 않아도 공지사항을 read할 수 있도록 특정 컬랙션 규칙을 수정했습니다.
  func makeNotificationCenterViewController() -> NotificationCenterViewController {
    return resolver.resolve(NotificationCenterViewController.self, name: .firebase)!
    // return resolver.resolve(NotificationCenterViewController.self, name: .implementation(.default))!
  }
}

// MARK: - LoginCoordinatorDependencies
extension AppDIContainer: LoginCoordinatorDependencies {
  func makeLoginViewController() -> LoginViewController {
    return resolver.resolve(LoginViewController.self)!
  }
}

// MARK: - PostDetailCoordinatorDependencies
extension AppDIContainer: PostDetailCoordinatorDependencies {
  func makePostDetailViewController(
    postId: PostIdentifier,
    post: Post?,
    coordinator: PostDetailCoordinator
  ) -> PostDetailViewController {
    return resolver.resolve(PostDetailViewController.self, arguments: coordinator, postId, post)!
  }
  
  func makeReviewWritingCoordinator(
    presenter: UINavigationController?,
    mode: ReviewWritingMode
  ) -> any SHCoordinator.FlowCoordinator {
    return container.resolve(ReviewWritingCoordinator.self, arguments: presenter, mode)!
  }
  
  func makePostDetailCategoryViewController(dataSource: [String]) -> UIViewController {
    return resolver.resolve(PostDetailCategoryViewController.self, argument: dataSource)!
  }
}

// MARK: - SearchCoordinatorDependencies
extension AppDIContainer: SearchCoordinatorDependencies {
  func makeSearchMoreDetailCoordinator(
    presenter: UINavigationController?
  ) -> SearchMoreDetailCoordinator {
    return resolver.resolve(SearchMoreDetailCoordinator.self, argument: presenter)!
  }
  
  func makeSearchHistoryCoordinator(
    presenter: UINavigationController?,
    searchType: SearchType
  ) -> SearchHistoryCoordinator {
    return resolver.resolve(SearchHistoryCoordinator.self, arguments: presenter, searchType)!
  }
  
  func makeSearchViewController(actions: SearchViewModelActions) -> SearchViewController {
    return resolver.resolve(SearchViewController.self, argument: actions)!
  }
}

// MARK: - SearchResultListCoordinatorDependencies
extension AppDIContainer: SearchResultListCoordinatorDependencies {
  func makeDestinationDetailCoordinator(
    presenter: UINavigationController?,
    destinationId: DestinationIdEntity
  ) -> DestinationDetailCoordinator {
    return resolver.resolve(DestinationDetailCoordinator.self, arguments: presenter, destinationId)!
  }
  
  func makeSearchResultListViewController(
    actions: SearchResultListViewModelActions,
    text: String
  ) -> SearchResultListViewController {
    return resolver.resolve(SearchResultListViewController.self, arguments: actions, text)!
  }
}

// MARK: - SearchHistoryCoordinatorDependencies
extension AppDIContainer: SearchHistoryCoordinatorDependencies {
  func makeSearchHistoryViewController(
    actions: SearchHistoryViewModelActions,
    searchType: SearchType
  ) -> SearchHistoryViewController {
    return resolver.resolve(SearchHistoryViewController.self, arguments: actions, searchType)!
  }
  
  func makeSearchResultListCoordinator(
    presenter: UINavigationController?,
    searchKeyword: String
  ) -> SearchResultListCoordinator {
    return resolver.resolve(SearchResultListCoordinator.self, arguments: presenter, searchKeyword)!
  }
}

// MARK: - DestinationDetailCoordinatorDependencies
extension AppDIContainer: DestinationDetailCoordinatorDependencies {
  func makeDestinationDetailViewController(
    destinationId: DestinationIdEntity,
    actions: DestinationDetailViewModelActions
  ) -> DestinationDetailViewController {
    resolver.resolve(DestinationDetailViewController.self, arguments: destinationId, actions)!
  }
}

// MARK: - SearchMoreDetailCoordinatorDependencies
extension AppDIContainer: SearchMoreDetailCoordinatorDependencies {
  func makeSearchMoreDetailViewController(
    actions: SearchMoreDetailViewModelActions,
    destinationInfos: [TravelDestinationInfo],
    headerTitle: String,
    searchSection: SearchSectionIndex
  ) -> SearchMoreDetailViewController {
    return resolver.resolve(
      SearchMoreDetailViewController.self,
      arguments: actions, destinationInfos, headerTitle, searchSection
    )!
  }
  
  func makeDestinationDetailCoordinator(
    presenter: UINavigationController?,
    destinationIdEntity: DestinationIdEntity
  ) -> DestinationDetailCoordinator {
    return resolver.resolve(DestinationDetailCoordinator.self, arguments: presenter, destinationIdEntity)!
  }
}

// MARK: - SettingCoordinatorDependencies
extension AppDIContainer: SettingCoordinatorDependencies {
  func makeSettingViewController(with actions: SettingViewModelActions) -> UIViewController {
    return resolver.resolve(SettingViewController.self, argument: actions)!
  }
  
  func makeOperatingGuideViewController() -> UIViewController {
    return resolver.resolve(OperationGuideViewController.self)!
  }
  
  func makeMyInformationCoordinator(presenter: UINavigationController?) -> any FlowCoordinator {
    return resolver.resolve(MyInformationCoordinator.self, argument: presenter)!
  }
  
  func makeCustomerServiceViewController() -> UIViewController {
    return resolver.resolve(CustomerServiceViewController.self)!
  }
}

// MARK: - MyInformationCoordinatorDependencies
extension AppDIContainer: MyInformationCoordinatorDependencies {
  func makeMyInformationViewController(with actions: MyInformationViewModelActions) -> UIViewController {
    return resolver.resolve(MyInformationViewController.self, argument: actions)!
  }
  
  func makeMyInformationAlbumSheetViewController() -> UIViewController {
    return resolver.resolve(MyInformationAlbumSheetViewController.self)!
  }
}

// MARK: -  ReviewWritingCoordinatorDependencies
extension AppDIContainer: ReviewWritingCoordinatorDependencies {
  func makeReviewWritingViewController(
    mode: ReviewWritingMode,
    actions: ReviewWritingViewModelActions,
    selectedAssetsPublisher: AnyPublisher<[PHAsset], Never>,
    selectedCategoryPublisher: AnyPublisher<Post.Category?, Never>
  ) -> ReviewWritingViewController {
    return container.resolve(
      ReviewWritingViewController.self,
      arguments: mode, actions, selectedAssetsPublisher, selectedCategoryPublisher)!
  }
  
  func makeAlbumCoordinator(presenter: UINavigationController?) -> AlbumCoordinator {
    return container.resolve(AlbumCoordinator.self, argument: presenter)!
  }
}

// MARK: - AlbumCoordinatorDependencies
extension AppDIContainer: AlbumCoordinatorDependencies {
  func makeAlbumViewController(
    parentPopPublisher: AnyPublisher<Void, Never>,
    actions: AlbumViewModelActions
  ) -> AlbumViewController {
    return container.resolve(AlbumViewController.self, arguments: parentPopPublisher, actions)!
  }
  
  func makeAlbumPhotoDetailCoordinator(presenter: UINavigationController?) -> AlbumPhotoDetailCoordinator {
    return container.resolve(AlbumPhotoDetailCoordinator.self, argument: presenter)!
  }
}

// MARK: - AlbumPhotoDetailCoordinatorDependencies
extension AppDIContainer: AlbumPhotoDetailCoordinatorDependencies {
  func makeAlbumPhotoDetailViewController(
    photoDetailModel: PhotoDetailModel,
    maxSelectPhotoCount: Int,
    actions: AlbumPhotoDetailViewModelActions
  ) -> AlbumPhotoDetailViewController {
    return container.resolve(
      AlbumPhotoDetailViewController.self,
      arguments: photoDetailModel, maxSelectPhotoCount, actions
    )!
  }
  
  func makeAlbumPhotoDetailViewController() -> AlbumPhotoDetailViewController {
    return container.resolve(AlbumPhotoDetailViewController.self)!
  }
}
