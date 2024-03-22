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
  private let travelMainThemeView = TravelMainThemeCategoryAreaView()
  
  /// 7개 테마 카테고리에 대한 상세 페이지 뷰
  private var pageViews: [UIViewController]!
  
  private lazy var postPageViewController = UIPageViewController(
    transitionStyle: .scroll,
    navigationOrientation: .horizontal
  ).set {
    $0.view.translatesAutoresizingMaskIntoConstraints = false
    $0.setViewControllers([pageViews[0]], direction: .forward, animated: true)
  }
  
  private var postPageView: UIView? {
    postPageViewController.view
  }
  
  private var presentedPageViewIndex = 0
  
  private let viewModel: CategoryPageViewDataSource
  
  private var adapter: CategoryPageViewAdapter?
  
  // MARK: - Lifecycle
  init(frame: CGRect, viewModel: CategoryPageViewDataSource, pageViews: [UIViewController]) {
    self.viewModel = viewModel
    self.pageViews = pageViews
    super.init(frame: frame)
    translatesAutoresizingMaskIntoConstraints = false
    setupUI()
    adapter = CategoryPageViewAdapter(
      dataSource: viewModel,
      delegate: self,
      travelThemeCollectionView: travelMainThemeView.travelThemeCategoryView)
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
}

// MARK: - Helpers
extension CategoryPageView {
  func handleOrderTypeFilter(with orderType: TravelOrderType?) {
    guard let targetViewController = postPageViewController.viewControllers?
      .first as? FeedPostViewController
    else { return }
    targetViewController.handleOrderTypeFilter(with: orderType)
  }
  
  func handleMainThemeFilter(with mainTheme: TravelMainThemeType?) {
    guard let targetViewController = postPageViewController.viewControllers?
      .first as? FeedPostViewController
    else { return }
    targetViewController.handleMainThemeFilter(with: mainTheme)
  }
}

// MARK: - Private Helpers
private extension CategoryPageView {
  func showCurrentPageView(fromSelectedIndex selectedIndex: Int) {
    guard selectedIndex != presentedPageViewIndex else { return }
    var direction: UIPageViewController.NavigationDirection
    direction = selectedIndex > presentedPageViewIndex ? .forward : .reverse
    presentedPageViewIndex = selectedIndex
    setCurrentPage(with: direction)
  }
  
  func setCurrentPage(with direction: UIPageViewController.NavigationDirection) {
    postPageViewController.setViewControllers(
      [pageViews[presentedPageViewIndex]],
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
    travelMainThemeView.drawScrollBar(
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
    travelMainThemeView.drawScrollBar(layoutTargetCell: cell, leadingInset: inset)
  }
}

// MARK: - LayoutSupport
extension CategoryPageView: LayoutSupport {
  func addSubviews() {
    addSubview(travelMainThemeView)
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
      travelMainThemeView.topAnchor.constraint(equalTo: topAnchor),
      travelMainThemeView.leadingAnchor.constraint(equalTo: leadingAnchor),
      travelMainThemeView.trailingAnchor.constraint(equalTo: trailingAnchor),
      travelMainThemeView.heightAnchor.constraint(equalToConstant: Const.size.height)]
  }
  
  var travelDetailThemePageViewConstraint: [NSLayoutConstraint] {
    guard let postPageView else { return [] }
    return [
      postPageView.leadingAnchor.constraint(equalTo: leadingAnchor),
      postPageView.topAnchor.constraint(equalTo: travelMainThemeView.bottomAnchor),
      postPageView.trailingAnchor.constraint(equalTo: trailingAnchor),
      postPageView.bottomAnchor.constraint(equalTo: bottomAnchor)]
  }
}
