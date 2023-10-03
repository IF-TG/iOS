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
  private let categoryScrollBarAreaView = TravelMainThemeCategoryAreaView()
  
  private var viewControllerDataSource: [UIViewController]!
  
  private lazy var travelDetailThemePageViewController = UIPageViewController(
    transitionStyle: .scroll,
    navigationOrientation: .horizontal
  ).set {
    $0.view.translatesAutoresizingMaskIntoConstraints = false
    $0.setViewControllers(
      [viewControllerDataSource[0]],
      direction: .forward,
      animated: true)
  }
  
  private var travelDetailThemePageView: UIView! {
    travelDetailThemePageViewController.view
  }
  
  private var travelDetailThemeFirstVC: TravelDetailThemeViewController {
    if let firstVC = viewControllerDataSource[0] as? TravelDetailThemeViewController {
      return firstVC
    }
    return .init(with: .init(travelTheme: .all, travelTrend: .newest))
  }
  
  private var presentedPageViewIndex = 0
  
  private let vm = CategoryPageViewModel()
  
  private var adapter: CategoryPageViewAdapter!
  
  // MARK: - Lifecycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureUI()
    adapter = CategoryPageViewAdapter(
      dataSource: vm,
      delegate: self,
      travelThemeCollectionView: categoryScrollBarAreaView.travelThemeCategoryView)
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    configureUI()
  }
  
  convenience init() {
    self.init(frame: .zero)
  }
}

// MARK: - Private Helpers
private extension CategoryPageView {
  func configureUI() {
    translatesAutoresizingMaskIntoConstraints = false
    viewControllerDataSource = (0..<vm.numberOfItems).map {
      let filterInfo = vm.postSearchFilterItem(at: $0)
      if $0+1 == vm.numberOfItems {
        return DevelopmentViewController(nibName: nil, bundle: nil)
      }
      return TravelDetailThemeViewController(with: filterInfo)
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
    travelDetailThemePageViewController.setViewControllers(
      [viewControllerDataSource[presentedPageViewIndex]],
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
    categoryScrollBarAreaView.drawScrollBar(
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
    categoryScrollBarAreaView.drawScrollBar(layoutTargetCell: cell, leadingInset: inset)
  }
}

// MARK: - LayoutSupport
extension CategoryPageView: LayoutSupport {
  func addSubviews() {
    _=[
      travelDetailThemePageView,
       categoryScrollBarAreaView
    ].map {
      addSubview($0)
    }
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
      categoryScrollBarAreaView.topAnchor.constraint(
        equalTo: topAnchor),
      categoryScrollBarAreaView.leadingAnchor.constraint(
        equalTo: leadingAnchor),
      categoryScrollBarAreaView.trailingAnchor.constraint(
        equalTo: trailingAnchor),
      categoryScrollBarAreaView.heightAnchor.constraint(
        equalToConstant:
          Const.size.height)]
  }
  
  var travelDetailThemePageViewConstraint: [NSLayoutConstraint] {
    return [
      travelDetailThemePageView.leadingAnchor.constraint(equalTo: leadingAnchor),
      travelDetailThemePageView.topAnchor.constraint(equalTo: categoryScrollBarAreaView.bottomAnchor),
      travelDetailThemePageView.trailingAnchor.constraint(equalTo: trailingAnchor),
      travelDetailThemePageView.bottomAnchor.constraint(equalTo: bottomAnchor)]
  }
}
