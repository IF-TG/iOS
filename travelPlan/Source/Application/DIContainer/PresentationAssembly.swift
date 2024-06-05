//
//  PresentationAssembly.swift
//  travelPlan
//
//  Created by 양승현 on 6/5/24.
//

import UIKit
import Swinject

final class PresentationAssembly: Assembly {
  func assemble(container: Swinject.Container) {
    // TODO: - Login Page
    
    // TODO: - PostDetail Page
    
    // TODO: - Post
    
    // TODO: - Notification Page
    
    // TODO: - Album Page
    
    // TODO: - Main Page
    
    // TODO: - Setting Page
    
    // TODO: - Favorite Page
    
    // TODO: - Search Page
    
    // TODO: - SearchDetail Page
    
    // TODO: - Plan Page
    
    // TODO: - ReviewWriting Page
    
    // TODO: - Feed Page
    container.register(DevelopmentViewController.self) { _ in
      DevelopmentViewController()
    }
    container.register(CategoryPageViewDataSource.self, name: .implementation(.default)) { _ in
      CategoryPageViewModel()
    }
    
    container.register((any FeedViewModelable).self) { _ in
      let backgroundQueue = DispatchQueue(
        label: "com.yeoga.app.feedViewModelQueue",
        qos: .default,
        attributes: .concurrent)
      return FeedViewModel(backgroundQueue: backgroundQueue)
    }
    
    container.register(
      (any FeedPostViewModelable & FeedPostViewAdapterDataSource).self,
      name: .implementation(.default)
    ) { (r, feedCategory: PostCategory) in
      let defaultPostFetchUseCase = r.resolve(PostFetchUseCase.self, name: .implementation(.default))!
      return FeedPostViewModel(postCategory: feedCategory, postFetchUsecase: defaultPostFetchUseCase)
    }
    
    container.register(
      (any FeedPostViewModelable & FeedPostViewAdapterDataSource).self,
      name: .testDouble(.mock)
    ) { (r, feedCategory: PostCategory) in
      let mockPostFetchUseCase = r.resolve(MockPostFetchUseCase.self)!
      return FeedPostViewModel(postCategory: feedCategory, postFetchUsecase: mockPostFetchUseCase)
      }
    
    container.register([UIViewController].self, name: "DefaultFeedPageViews") { r in
      let categoryPageViewModel = r.resolve(CategoryPageViewDataSource.self, name: .implementation(.default))!
      return (0..<categoryPageViewModel.numberOfItems).map {
        let feedCategory = categoryPageViewModel.postSearchFilterItem(at: $0)
        if $0 + 1 == categoryPageViewModel.numberOfItems {
          return r.resolve(DevelopmentViewController.self)!
        }
        let feedPostViewModel = r.resolve(
          (any FeedPostViewModelable & FeedPostViewAdapterDataSource).self, name: .implementation(.default))!
        return FeedPostViewController(type: feedCategory, viewModel: feedPostViewModel)
      }
    }
    
    container.register([UIViewController].self, name: "MockFeedPageViews") { r in
      let categoryPageViewModel = r.resolve(CategoryPageViewDataSource.self, name: .implementation(.default))!
      return (0..<categoryPageViewModel.numberOfItems).map {
        let feedCategory = categoryPageViewModel.postSearchFilterItem(at: $0)
        if $0 + 1 == categoryPageViewModel.numberOfItems {
          return r.resolve(DevelopmentViewController.self)!
        }
        let feedPostViewModel = r.resolve(
          (any FeedPostViewModelable & FeedPostViewAdapterDataSource).self, name: .testDouble(.mock))!
        return FeedPostViewController(type: feedCategory, viewModel: feedPostViewModel)
      }
      
    }
    
    container.register(FeedViewController.self, name: .implementation(.default)) { r in
      let defaultPageViews = r.resolve([UIViewController].self, name: "DefaultFeedPageViews")!
      let feedViewModel = r.resolve((any FeedViewModelable).self)!
      let categoryPageViewModel = r.resolve(CategoryPageViewDataSource.self)!
      return FeedViewController(
        viewModel: feedViewModel,
        categoryPageViewModel: categoryPageViewModel,
        pageViews: defaultPageViews)
    }
    
    container.register(FeedViewController.self, name: .testDouble(.mock)) { r in
      let mockPageViews = r.resolve([UIViewController].self, name: "MockFeedPageViews")!
      let feedViewModel = r.resolve((any FeedViewModelable).self)!
      let categoryPageViewModel = r.resolve(CategoryPageViewDataSource.self)!
      return FeedViewController(
        viewModel: feedViewModel,
        categoryPageViewModel: categoryPageViewModel,
        pageViews: mockPageViews)
    }
  }
}
