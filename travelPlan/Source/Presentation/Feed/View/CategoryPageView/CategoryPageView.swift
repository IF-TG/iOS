//
//  CategoryPageView.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/09.
//

import UIKit

/// Horizontal category page view
final class CategoryPageView: UIView {
  // MARK: - Properties
  /// 전체, 계절, 지역 ... 7개 테마 카테고리 뷰
  private let travelMainThemeCategoryView = TravelMainThemeCategoryAreaView()
  
  /// 7개 테마 카테고리에 대한 상세 뷰
  private var pageViewDataSource: [UIViewController]!
  
  private lazy var postPageViewController = UIPageViewController(
    transitionStyle: .scroll,
    navigationOrientation: .horizontal
  ).set {
    $0.view.translatesAutoresizingMaskIntoConstraints = false
    $0.setViewControllers(
      [pageViewDataSource[0]],
      direction: .forward,
      animated: true)
  }
  
  private var postPageView: UIView? {
    postPageViewController.view
  }
  
  private var presentedPageViewIndex = 0
  
  private let viewModel: CategoryPageViewDataSource
  
  private var adapter: CategoryPageViewAdapter?
  
  // MARK: - Lifecycle
  init(frame: CGRect, viewModel: CategoryPageViewDataSource) {
    self.viewModel = viewModel
    super.init(frame: frame)
    configureUI()
    adapter = CategoryPageViewAdapter(
      dataSource: viewModel,
      delegate: self,
      travelThemeCollectionView: travelMainThemeCategoryView.travelThemeCategoryView)
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
}

// MARK: - Helpers
extension CategoryPageView {
  func setDefaultSortingHeaderUI(from sortingType: PostFilterOptions) {
    guard let targetViewController = postPageViewController.viewControllers?
      .first as? FeedPostViewController
    else { return }
    switch sortingType {
    case .travelOrder:
      targetViewController.setDefaultOrderUI()
    case .travelMainTheme:
      targetViewController.setDefaultThemeUI()
    }
  }
}

// MARK: - Private Helpers
private extension CategoryPageView {
  func configureUI() {
    translatesAutoresizingMaskIntoConstraints = false
    pageViewDataSource = (0..<viewModel.numberOfItems).map {
      let feedCategory = viewModel.postSearchFilterItem(at: $0)
      if $0+1 == viewModel.numberOfItems {
        return DevelopmentViewController(nibName: nil, bundle: nil)
      }
      let postUseCase = DefaultPostUseCase(postRepository: MockPostRepository())
      let viewModel = FeedPostViewModel(postCategory: feedCategory, postUseCase: postUseCase)
      
      return FeedPostViewController(
        with: feedCategory,
        viewModel: viewModel)
      // TODO: - 코디네이터로 이동해보리어야함
    }
    setupUI()
  }
  
  func showCurrentPageView(fromSelectedIndex selectedIndex: Int) {
    guard selectedIndex != presentedPageViewIndex else { return }
    var direction: UIPageViewController.NavigationDirection
    direction = selectedIndex > presentedPageViewIndex ? .forward : .reverse
    presentedPageViewIndex = selectedIndex
    setCurrentPage(with: direction)
  }
  
  func setCurrentPage(with direction: UIPageViewController.NavigationDirection) {
    postPageViewController.setViewControllers(
      [pageViewDataSource[presentedPageViewIndex]],
      direction: direction,
      animated: true)
  }
}

// MARK: - CategoryPageViewDelegate
extension CategoryPageView: CategoryPageViewDelegate {
  func collectionView(
    _ collectionView: UICollectionView,
    willDisplayFirstCell cell: UICollectionViewCell,
    scrollBarLeadingInset leadingInset: CGFloat
  ) {
    travelMainThemeCategoryView.drawScrollBar(
      layoutTargetCell: cell,
      leadingInset: leadingInset,
      animation: false)
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    didSelectItemAt indexPath: IndexPath,
    scrollBarLeadingInset inset: CGFloat
  ) {
    let cell = collectionView.cellForItem(at: indexPath)
    showCurrentPageView(fromSelectedIndex: indexPath.row)
    travelMainThemeCategoryView.drawScrollBar(layoutTargetCell: cell, leadingInset: inset)
  }
}

// MARK: - LayoutSupport
extension CategoryPageView: LayoutSupport {
  func addSubviews() {
    addSubview(travelMainThemeCategoryView)
    guard let postPageView else {
      print("DEBUG: PostPageView 생성 x")
      return
    }
    addSubview(postPageView)
  }
  
  func setConstraints() {
    _=[
      categoryViewConstraint,
      travelDetailThemePageViewConstraint
    ].map {
      NSLayoutConstraint.activate($0)
    }
  }
}

// MARK: - LayoutSupport constraints
private extension CategoryPageView {
  var categoryViewConstraint: [NSLayoutConstraint] {
    typealias Const = TravelMainThemeCategoryAreaView.Constant
    return [
      travelMainThemeCategoryView.topAnchor.constraint(equalTo: topAnchor),
      travelMainThemeCategoryView.leadingAnchor.constraint(equalTo: leadingAnchor),
      travelMainThemeCategoryView.trailingAnchor.constraint(equalTo: trailingAnchor),
      travelMainThemeCategoryView.heightAnchor.constraint(equalToConstant: Const.size.height)]
  }
  
  var travelDetailThemePageViewConstraint: [NSLayoutConstraint] {
    guard let postPageView else { return [] }
    return [
      postPageView.leadingAnchor.constraint(equalTo: leadingAnchor),
      postPageView.topAnchor.constraint(equalTo: travelMainThemeCategoryView.bottomAnchor),
      postPageView.trailingAnchor.constraint(equalTo: trailingAnchor),
      postPageView.bottomAnchor.constraint(equalTo: bottomAnchor)]
  }
}
