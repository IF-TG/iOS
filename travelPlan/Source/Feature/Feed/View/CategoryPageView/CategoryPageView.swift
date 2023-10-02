//
//  CategoryPageView.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/09.
//

import UIKit
import Combine

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
  
  private var subscription: AnyCancellable?
  
  // MARK: - Initialization
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureUI()
    bind()
    adapter = CategoryPageViewAdapter(
      dataSource: vm,
      delegate: self,
      travelThemeCollectionView: categoryScrollBarAreaView.travelThemeCategoryView)
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    configureUI()
    bind()
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
  
  func bind() {
    subscription = travelDetailThemeFirstVC
      .itemSizeSetNotifier
      .receive(on: DispatchQueue.main)
      .sink { [unowned self] in
        let categoryfirstText = vm.travelMainCategoryTitle(at: 0)
        let firstIndex = IndexPath(item: 0, section: 0)
        categoryScrollBarAreaView.setInitialVisibleSubviews(from: categoryfirstText)
        categoryScrollBarAreaView.selectedItem(at: firstIndex, animated: false, scrollPosition: .left)
      }
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
  func didSelectItemAt(_ indexPath: IndexPath, spacing: CGFloat) {
    guard let cell = categoryScrollBarAreaView.selectedCell(at: indexPath) else { return }
    categoryScrollBarAreaView.selectedItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
    showCurrentPageView(fromSelectedIndex: indexPath.row)
    categoryScrollBarAreaView.drawScrollBar(target: cell, fromLeading: spacing)
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
