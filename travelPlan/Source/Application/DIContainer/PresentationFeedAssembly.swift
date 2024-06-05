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
    }
    
    // MARK: - FeedPostViewModel
    container.register(
      (any FeedPostViewModelable & FeedPostViewAdapterDataSource).self,
      name: .implementation(.default)
    ) { (r, feedCategory: PostCategory) in
      let defaultPostFetchUseCase = r.resolve(PostFetchUseCase.self, name: .implementation(.default))!
      return FeedPostViewModel(postCategory: feedCategory, postFetchUsecase: defaultPostFetchUseCase)
    }
    
    container.register(
      (any FeedPostViewModelable & FeedPostViewAdapterDataSource).self,
      name: .implementation(.interceptedDefault)
    ) { (r, feedCategory: PostCategory) in
      let interceptedPostFetchUseCase = r.resolve(PostFetchUseCase.self, name: .implementation(.interceptedDefault))!
      return FeedPostViewModel(postCategory: feedCategory, postFetchUsecase: interceptedPostFetchUseCase)
    }
    
    container.register(
      (any FeedPostViewModelable & FeedPostViewAdapterDataSource).self,
      name: .testDouble(.mock)
    ) { (r, feedCategory: PostCategory) in
      let mockPostFetchUseCase = r.resolve(PostFetchUseCase.self, name: .testDouble(.mock))!
      return FeedPostViewModel(postCategory: feedCategory, postFetchUsecase: mockPostFetchUseCase)
    }
    
    // MARK: - FeedPostViewController
    container.register([UIViewController].self, name: "DefaultFeedPageViews") { (r, coordinator: FeedCoordinator) in
      let categoryPageViewModel = r.resolve(CategoryPageViewDataSource.self)!
      return (0..<categoryPageViewModel.numberOfItems).map {
        let feedCategory = categoryPageViewModel.postSearchFilterItem(at: $0)
        if $0 + 1 == categoryPageViewModel.numberOfItems {
          return r.resolve(DevelopmentViewController.self)!
        }
        let feedPostViewModel = r.resolve(
          (any FeedPostViewModelable & FeedPostViewAdapterDataSource).self,
          name: .implementation(.default),
          argument: feedCategory)!
        return FeedPostViewController(
          type: feedCategory,
          viewModel: feedPostViewModel
        ).set {
          $0.coordinator = coordinator
        }
      }
    }
    
    container.register([UIViewController].self, name: "MockFeedPageViews") { (r, coordinator: FeedCoordinator) in
      let categoryPageViewModel = r.resolve(CategoryPageViewDataSource.self)!
      return (0..<categoryPageViewModel.numberOfItems).map {
        let feedCategory = categoryPageViewModel.postSearchFilterItem(at: $0)
        if $0 + 1 == categoryPageViewModel.numberOfItems {
          return r.resolve(DevelopmentViewController.self)!
        }
        let feedPostViewModel = r.resolve(
          (any FeedPostViewModelable & FeedPostViewAdapterDataSource).self,
          name: .testDouble(.mock),
          argument: feedCategory)!
        return FeedPostViewController(
          type: feedCategory,
          viewModel: feedPostViewModel
        ).set {
          $0.coordinator = coordinator
        }
      }
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
