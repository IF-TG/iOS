//
//  PresentationFeedAssembly.swift
//  travelPlan
//
//  Created by 양승현 on 6/6/24.
//

import UIKit
import Swinject

final class PresentationFeedAssembly: Assembly {
  // swiftlint:disable function_body_length
  func assemble(container: Swinject.Container) {
    // MARK: - Feed Page
    container.register(DevelopmentViewController.self) { _ in
      DevelopmentViewController()
    }
    
    container.register(CategoryPageViewDataSource.self) { _ in
      CategoryPageViewModel()
    }
    
    // MARK: - FeedViewModel
    container.register((any FeedViewModelable).self) { _ in
      let backgroundQueue = DispatchQueue(
        label: "com.yeoga.app.feedViewModelQueue",
        qos: .default,
        attributes: .concurrent)
      return FeedViewModel(backgroundQueue: backgroundQueue)
    }.inObjectScope(.transient)
    
    // MARK: - FeedPostViewModel
    container.register(
      (any FeedPostViewModelable & FeedPostViewAdapterDataSource).self
    ) { (r, feedCategory: PostCategory) in
      let defaultPostFetchUseCase = r.resolve(PostFetchUseCase.self)!
      return FeedPostViewModel(postCategory: feedCategory, postFetchUseCase: defaultPostFetchUseCase)
    }.inObjectScope(.transient)
    
    // MARK: - FeedPostViewController
    let categoryPageViewMdoel = container.resolve(CategoryPageViewDataSource.self)!
    let feedPageServiceNames = makeFeedPageCategoryServiceNames(categoryPageViewMdoel)
    let numberOfCategories = categoryPageViewMdoel.numberOfItems
    
    /// 마지막 인덱스는 개발자 페이지인데, 위에서 이미 등록됬습니다.
    for index in 0..<numberOfCategories - 1 {
      let feedCategory = categoryPageViewMdoel.postSearchFilterItem(at: index)
      let feedPageServiceName = feedPageServiceNames[index]
      
      // MARK: - 피드 페이지뷰컨트롤러 default, mock register.
      container.register(
        UIViewController.self,
        name: feedPageServiceName
      ) { (r, coordinator: FeedCoordinator) in
        let defaultFeedPostViewModel = self.resolveFeedPostViewModel(
          r,
          arguemnt: feedCategory)
        let defaultPostOptionViewModel = self.resolvePostOptionViewModel(
          r,
          actions: coordinator.makePostOptionViewModelActions(),
          mainThemeType: feedCategory.mainTheme)
        return FeedPostViewController(
          type: feedCategory,
          viewModel: defaultFeedPostViewModel,
          postOptionViewModel: defaultPostOptionViewModel)
        .set {
          $0.coordinator = coordinator
        }
      }.inObjectScope(.transient)
    }
    
    // MARK: - FeedPageViewControllers
    container.register([UIViewController].self, name: "DefaultFeedPageViews") { (r, coordinator: FeedCoordinator) in
      let defaultFeedPageViewControllers = (0..<numberOfCategories-1).map {
        r.resolve(
          UIViewController.self,
          name: feedPageServiceNames[$0], argument: coordinator)!
      }
      return defaultFeedPageViewControllers + [r.resolve(DevelopmentViewController.self)!]
    }.inObjectScope(.transient)
    
    // MARK: - FeedViewController
    container.register(FeedViewController.self) { (r, coordinator: FeedCoordinator) in
      let defaultPageViews = r.resolve(
        [UIViewController].self,
        name: "DefaultFeedPageViews",
        argument: coordinator)!
      let feedViewModel = r.resolve((any FeedViewModelable).self)!
      let categoryPageViewModel = r.resolve(CategoryPageViewDataSource.self)!
      return FeedViewController(
        viewModel: feedViewModel,
        categoryPageViewModel: categoryPageViewModel,
        pageViews: defaultPageViews
      ).set {
        $0.coordinator = coordinator
      }
    }
  }
  // swiftlint:enable function_body_length
}

// MARK: - Private Helpers
private extension PresentationFeedAssembly {
  func makeFeedPageCategoryServiceNames(_ categoryPageDataSource: CategoryPageViewDataSource) -> [String] {
    return (0..<categoryPageDataSource.numberOfItems).map {
      categoryPageDataSource.travelMainCategoryTitle(at: $0)
    }
  }
  
  func resolveFeedPostViewModel(
    _ r: Resolver,
    arguemnt: PostCategory
  ) -> (any FeedPostViewModelable & FeedPostViewAdapterDataSource) {
    r.resolve(
      (any FeedPostViewModelable & FeedPostViewAdapterDataSource).self,
      argument: arguemnt)!
  }
  
  func resolvePostOptionViewModel(
    _ r: Resolver,
    actions: PostOptionViewModelActions,
    mainThemeType: TravelMainThemeType?
  ) -> PostOptionViewModelType {
    let dataSource = PostOptionViewModelInfo(postOptionLocation: .summaryPage(mainThemeType))
    return r.resolve(
      PostOptionViewModelType.self,
      arguments: dataSource, actions)!
  }
}
