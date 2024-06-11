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
      (any FeedPostViewModelable & FeedPostViewAdapterDataSource).self,
      name: .implementation(.default)
    ) { (r, feedCategory: PostCategory) in
      let defaultPostFetchUseCase = r.resolve(PostFetchUseCase.self, name: .implementation(.default))!
      return FeedPostViewModel(postCategory: feedCategory, postFetchUseCase: defaultPostFetchUseCase)
    }.inObjectScope(.transient)
    
    container.register(
      (any FeedPostViewModelable & FeedPostViewAdapterDataSource).self,
      name: .implementation(.interceptedDefault)
    ) { (r, feedCategory: PostCategory) in
      let interceptedPostFetchUseCase = r.resolve(PostFetchUseCase.self, name: .implementation(.interceptedDefault))!
      return FeedPostViewModel(postCategory: feedCategory, postFetchUseCase: interceptedPostFetchUseCase)
    }.inObjectScope(.transient)
    
    container.register(
      (any FeedPostViewModelable & FeedPostViewAdapterDataSource).self,
      name: .testDouble(.mock)
    ) { (r, feedCategory: PostCategory) in
      let mockPostFetchUseCase = r.resolve(PostFetchUseCase.self, name: .testDouble(.mock))!
      return FeedPostViewModel(postCategory: feedCategory, postFetchUseCase: mockPostFetchUseCase)
    }.inObjectScope(.transient)
    
    // MARK: - FeedPostViewController
    let categoryPageViewMdoel = container.resolve(CategoryPageViewDataSource.self)!
    let feedPageServiceNames = makeFeedPageCategoryServiceNames(categoryPageViewMdoel)
    let defaultFeedPageServiceNames = makeDefaultFeedPageServiceNames(feedPageServiceNames)
    let mockFeedPageServiceNames = makeMockFeedPageServiceNames(feedPageServiceNames)
    let numberOfCategories = categoryPageViewMdoel.numberOfItems
    
    /// 마지막 인덱스는 개발자 페이지인데, 위에서 이미 등록됬습니다.
    for index in 0..<numberOfCategories - 1 {
      let feedCategory = categoryPageViewMdoel.postSearchFilterItem(at: index)
      let defaultFeedPageServiceName = feedPageServiceNames[index]
      let mockFeedPageServiceName = mockFeedPageServiceNames[index]
      
      // MARK: - 피드 페이지뷰컨트롤러 default, mock register.
      container.register(
        UIViewController.self,
        name: defaultFeedPageServiceName
      ) { (r, coordinator: FeedCoordinator) in
        let defaultFeedPostViewModel = self.resolveFeedPostViewModel(
          r,
          serviceName: .implementation(.default),
          arguemnt: feedCategory)
        let defaultPostOptionViewModel = self.resolvePostOptionViewModel(
          r,
          serviceName: .implementation(.default),
          actions: coordinator.makePostOptionViewModelActions())
        return FeedPostViewController(
          type: feedCategory,
          viewModel: defaultFeedPostViewModel,
          postOptionViewModel: defaultPostOptionViewModel)
      }
      
      container.register(UIViewController.self, name: mockFeedPageServiceName) { (r, coordinator: FeedCoordinator) in
        let mockFeedPostVM = self.resolveFeedPostViewModel(
          r,
          serviceName: .testDouble(.mock),
          arguemnt: feedCategory)
        let mockPostOptionVM = self.resolvePostOptionViewModel(
          r,
          serviceName: .testDouble(.mock),
          actions: coordinator.makePostOptionViewModelActions())
        return FeedPostViewController(
          type: feedCategory,
          viewModel: mockFeedPostVM,
          postOptionViewModel: mockPostOptionVM)
      }
    }
    
    // MARK: - FeedPageViewControllers
    container.register([UIViewController].self, name: "DefaultFeedPageViews") { (r, coordinator: FeedCoordinator) in
      let defaultFeedPageViewControllers = (0..<numberOfCategories-1).map {
        r.resolve(
          UIViewController.self,
          name: defaultFeedPageServiceNames[$0], argument: coordinator)!
      }
      return defaultFeedPageViewControllers + [r.resolve(DevelopmentViewController.self)!]
    }
    
    container.register([UIViewController].self, name: "MockFeedPageViews") { (r, coordinator: FeedCoordinator) in
      let mockFeedPageViewControllers = (0..<numberOfCategories-1).map {
        r.resolve(
          UIViewController.self,
          name: mockFeedPageServiceNames[$0], argument: coordinator)!
      }
      return mockFeedPageViewControllers + [r.resolve(DevelopmentViewController.self)!]
    }
    
    // MARK: - FeedViewController
    container.register(FeedViewController.self, name: .implementation(.default)) { (r, coordinator: FeedCoordinator) in
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
    
    container.register(FeedViewController.self, name: .testDouble(.mock)) { (r, coordinator: FeedCoordinator) in
      let mockPageViews = r.resolve(
        [UIViewController].self,
        name: "MockFeedPageViews",
        argument: coordinator)!
      let feedViewModel = r.resolve((any FeedViewModelable).self)!
      let categoryPageViewModel = r.resolve(CategoryPageViewDataSource.self)!
      return FeedViewController(
        viewModel: feedViewModel,
        categoryPageViewModel: categoryPageViewModel,
        pageViews: mockPageViews
      ).set {
        $0.coordinator = coordinator
      }
    }
  }
  // swiftlint:enable function_body_length
}

// MARK: - Private Helpers
private extension PresentationFeedAssembly {
  typealias PostOptionViewModelType = any PostOptionViewModelable & PostOptionViewModelPageDelegate
  
  func makeFeedPageCategoryServiceNames(_ categoryPageDataSource: CategoryPageViewDataSource) -> [String] {
    return (0..<categoryPageDataSource.numberOfItems).map {
      categoryPageDataSource.travelMainCategoryTitle(at: $0)
    }
  }
  
  func makeDefaultFeedPageServiceNames(_ mainCategoryTitles: [String]) -> [String] {
    return mainCategoryTitles.map { "default" + $0 }
  }
  
  func makeMockFeedPageServiceNames(_ mainCategoryTitles: [String]) -> [String] {
    return mainCategoryTitles.map { "mock" + $0 }
  }
  
  func resolveFeedPostViewModel(
    _ r: Resolver,
    serviceName: ServiceName,
    arguemnt: PostCategory
  ) -> (any FeedPostViewModelable & FeedPostViewAdapterDataSource) {
    r.resolve(
      (any FeedPostViewModelable & FeedPostViewAdapterDataSource).self,
      name: serviceName,
      argument: arguemnt)!
  }
  
  func resolvePostOptionViewModel(
    _ r: Resolver,
    serviceName: ServiceName,
    actions: PostOptionViewModelActions
  ) -> PostOptionViewModelType {
    return r.resolve(
      PostOptionViewModelType.self,
      name: serviceName,
      arguments: nil as Int32?, nil as Int32?, nil as String?,
      PostOptionLocation.summaryPage, actions)!
  }
}
