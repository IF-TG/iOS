//
//  FeedCoordinator.swift
//  travelPlan
//
//  Created by 양승현 on 2023/06/30.
//

import UIKit
import SHCoordinator

protocol FeedPostCoordinatorDelegate: AnyObject {
  func showDetailPost(post: Post, category: Post.Category)
}

protocol FeedCoordinatorDelegate: FlowCoordinatorDelegate {
  func showPostSearch()
  func showNotification()
  func showTotalBottomSheet()
  func showPostMainThemeCategoryBottomSheet(mainTheme: TravelMainThemeType)
  func showPostOrderCategoryBottomSheet()
  func showReviewWrite()
}

final class FeedCoordinator: FlowCoordinator {
  // MARK: - Properties
  var parent: FlowCoordinator?
  var child: [FlowCoordinator] = []
  var presenter: UINavigationController?
  
  private weak var viewController: FeedViewController?
  
  init(presenter: UINavigationController?) {
    self.presenter = presenter
  }
  
  // MARK: - Helpers
  func start() {
    let feedViewModel = FeedViewModel()
    let categoryPageViewModel = CategoryPageViewModel()
    let pageViews = makeFeedPageViews(with: categoryPageViewModel)
    let vc = FeedViewController(
      viewModel: feedViewModel,
      categoryPageViewModel: categoryPageViewModel, 
      pageViews: pageViews)
    viewController = vc
    vc.coordinator = self
    presenter?.pushViewController(vc, animated: true)
  }
  
  private func makeFeedPageViews(
    with categoryPageViewModel: CategoryPageViewDataSource
  ) -> [UIViewController] {
    return (0..<categoryPageViewModel.numberOfItems).map {
      let feedCategory = categoryPageViewModel.postSearchFilterItem(at: $0)
      if $0 + 1 == categoryPageViewModel.numberOfItems {
        return DevelopmentViewController()
      }
      // FIXME: - 실제로 서버 통신하게된다면 DefaultPostUseCase 써야합니다.
      // 지금은 페이징 테스트때문에 MockPostUseCaseForPaging을 사용합니다.
      // MockPostRepository()를 통해서 실제 서버의 resopnseDTO를 decodable한 데이터들을 처럼
      // mock json을 받을 수 있지만 포스트가 3개 정보밖에 없습니다.
      // let postUseCase = DefaultPostUseCase(postRepository: MockPostRepository())
      let mockPostUseCase = MockPostUseCaseForPaging()
      let viewModel = FeedPostViewModel(postCategory: feedCategory, postUseCase: mockPostUseCase)
      return FeedPostViewController(type: feedCategory, viewModel: viewModel)
        .set { $0.coordinator = self }
    }
  }
}

// MARK: - FeedPostCoordinatorDelegate
extension FeedCoordinator: FeedPostCoordinatorDelegate {
  func showDetailPost(post: Post, category: Post.Category) {
    let childCoordinator = PostDetailCoordinator(presenter: presenter, post: post, category: category)
    addChild(with: childCoordinator)
  }
}

// MARK: - FeedCoordinatorDelegate
extension FeedCoordinator: FeedCoordinatorDelegate {  
  func showPostSearch() {
    let childCoordinator = PostSearchCoordinator(presenter: presenter)
    addChild(with: childCoordinator)
  }
  
  func showNotification() {
    let childCoordinator = NotificationCenterCoordinator(presenter: presenter)
    addChild(with: childCoordinator)
  }
  
  func showTotalBottomSheet() {
    let sheetViewController = PostViewBottomSheetViewController()
    presenter?.present(sheetViewController, animated: false)
  }
  
  // FIXME: - 피드 탭에서 분류, 정렬 title은 그대로 두고 이제 바텀시트 올라올 때 선택됬던거는 살짝 체크표시?
  // 카테고리 선정시 옆에 태그 형식으로 붙여주는것도 괜찮은 선택지,,
  func showPostMainThemeCategoryBottomSheet(mainTheme: TravelMainThemeType) {
    let bottomSheet = PostMainThemeCategoryBottomSheet(mainTheme: mainTheme)
    bottomSheet.delegate = viewController
    presenter?.presentBottomSheet(bottomSheet)
  }
  
  func showPostOrderCategoryBottomSheet() {
    let bottomSheet = PostOrderCategoryBottomSheet()
    bottomSheet.delegate = viewController
    presenter?.presentBottomSheet(bottomSheet)
  }
  
  func showReviewWrite() {
    // 임시 test 코드
    let contents: [PostContentEntity] = [
      .text("텍스트1텍스트2텍스트3텍스트4텍스트5텍스트6텍스트7텍스트8텍스트9텍스트10텍스트11텍스트12텍스트13텍스트14텍스트15텍스트16텍스트17"),
      .image(UIImage(named: "tempProfile4")!.jpegData(compressionQuality: 1.0)!),
      .text("텍스트1텍스트2텍스트3텍스트4텍스트5텍스트6텍스트7텍스트8텍스트9텍스트10텍스트11텍스트12텍스트13텍스트14텍스트15텍스트16텍스트17"),
      .text("text1text2text3text4text5text6text7text8text9text10text11text12text13text14text15text16text17"),
      .image(UIImage(named: "tempProfile4")!.jpegData(compressionQuality: 1.0)!),
      .image(UIImage(named: "tempProfile4")!.jpegData(compressionQuality: 1.0)!)
    ]
    let entity = ReviewWritingEntity(
      category: .init(themes: [.adventure],
                      regions: [.busan],
                      seasons: [.fall],
                      partners: [.alone]),
      tripData: .init(start: "2023", end: "2024"),
      title: "제목입니다.", contents: contents
    )
    let reviewWritingCoordinator = ReviewWritingCoordinator(presenter: presenter, mode: .edit(entity))
    
//    let reviewWritingCoordinator = ReviewWritingCoordinator(presenter: presenter, mode: .start)
    addChild(with: reviewWritingCoordinator)
  }
}
