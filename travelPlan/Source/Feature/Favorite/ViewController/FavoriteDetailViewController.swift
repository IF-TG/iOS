//
//  FavoriteDetailViewController.swift
//  travelPlan
//
//  Created by 양승현 on 10/3/23.
//

import UIKit

final class FavoriteDetailViewController: UIViewController {
  enum Constant {
    enum CategoryView {
      static let height: CGFloat = 98
    }
    enum BackButtonItem {
      static let imageName = "back"
      static let titleColor = UIColor.yg.gray7
      static let fontSize: CGFloat = 16
    }
  }
  
  // MARK: - Properties
  private let safeAreaTopBackgroundView = UIView(frame: .zero).set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = .white
  }
  
  private lazy var menuView = FavoriteDetailMenuAreaView(
    totalItemCount: pageViewDataSource[0].numberOfItems)
  
  private var pageViewDataSource: [
    EmptyStateBasedContentViewController
    & FavoriteDetailMenuViewConfigurable]!
  
  private lazy var pageViewController = UIPageViewController(
    transitionStyle: .scroll,
    navigationOrientation: .horizontal
  ).set {
    $0.view.translatesAutoresizingMaskIntoConstraints = false
    $0.setViewControllers(
      [pageViewDataSource[0]],
      direction: .forward,
      animated: true)
  }
  
  private var pageView: UIView! {
    pageViewController.view
  }
  
  private lazy var backButton = UIButton().set {
    typealias Const = Constant.BackButtonItem
    let iconName = Const.imageName
    let image = UIImage(named: iconName)?.withRenderingMode(.alwaysOriginal)
    let attributes: [NSAttributedString.Key: Any] = [.font: UIFont(pretendard: .medium, size: Const.fontSize)!]
    let attrString = NSAttributedString(string: "찜 목록", attributes: attributes)
    $0.setImage(image, for: .normal)
    $0.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
    $0.setTitleColor(Const.titleColor, for: .normal)
    $0.setAttributedTitle(attrString, for: .normal)
  }
  
  private var categoryViewTargetTransform = CGAffineTransform()
  
  private var pageViewOriginTopAnchor: NSLayoutConstraint!
  
  private var pageViewTopAnchor: NSLayoutConstraint!
  
  private var isDoneCategoryViewAnimation = true
  
  weak var coordinator: FavoriteDetailCoordinatorDelegate?
  
  // MARK: - Lifecycle
  init() {
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
    bind()
  }
  
  deinit {
    coordinator?.finish()
  }
}

// MARK: - Private Helpers
private extension FavoriteDetailViewController {
  func configureUI() {
    let favoritePostViewController = FavoritePostViewController().set {
      $0.delegate = self
    }
    let favoriteLocationViewController = FavoriteLocationViewController()
    pageViewDataSource = [favoritePostViewController, favoriteLocationViewController]
    view.backgroundColor = .white
    setupUI()
    setNavigationUI()
  }
  
  private func setNavigationUI() {
    let barItem = UIBarButtonItem(customView: backButton)
    navigationItem.leftBarButtonItem = barItem
  }
  
  func bind() {
    menuView.travelReviewTapHandler = {
      let targetViewController = self.pageViewDataSource[0]
      self.pageViewController.setViewControllers(
        [targetViewController],
        direction: .reverse,
        animated: true)
      
      return targetViewController.numberOfItems
    }
    
    menuView.travelLocationTapHandler = {
      let targetViewController = self.pageViewDataSource[1]
      self.pageViewController.setViewControllers(
        [targetViewController],
        direction: .forward,
        animated: true)
      return targetViewController.numberOfItems
    }
  }
}

// MARK: - Action
extension FavoriteDetailViewController {
  @objc private func didTapBackButton() {
    navigationController?.popViewController(animated: true)
  }
}

// MARK: - FavoritePostViewDelegate
extension FavoriteDetailViewController: FavoritePostViewDelegate {
  func scrollDidScroll(
    _ scrollView: UIScrollView,
    scrollYPosition: CGFloat,
    direction: UIScrollView.ScrollVerticalDirection
  ) {
    guard isDoneCategoryViewAnimation else { return }
    prepareSubviewsForScrollAnimation()
    setSubviesPositionForScrollAnimation(from: direction)
    showSubviewsScrollAnimation()
  }
  
  private func prepareSubviewsForScrollAnimation() {
    isDoneCategoryViewAnimation = false
    pageViewTopAnchor.isActive = false
  }
  
  private func setSubviesPositionForScrollAnimation(
    from direction: UIScrollView.ScrollVerticalDirection
  ) {
    if direction == .up {
      pageViewTopAnchor = pageViewOriginTopAnchor
      categoryViewTargetTransform = .identity
      return
    }
    pageViewTopAnchor = pageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
    categoryViewTargetTransform = .init(translationX: 0, y: -Constant.CategoryView.height)
  }
  
  private func showSubviewsScrollAnimation() {
    pageViewTopAnchor.isActive = true
    UIView.transition(
      with: menuView,
      duration: 0.3,
      options: .curveEaseOut,
      animations: {
        self.menuView.transform = self.categoryViewTargetTransform
        self.view.layoutIfNeeded()
      }, completion: { _ in
        self.isDoneCategoryViewAnimation = true
      })
  }
}

// MARK: - LayoutSupport
extension FavoriteDetailViewController: LayoutSupport {
  func addSubviews() {
    _=[
      pageView,
      menuView,
      safeAreaTopBackgroundView
    ].map {
      view.addSubview($0)
    }
  }
  
  func setConstraints() {
    _=[
      safeAreaTopBackgroundViewConstraints,
      categoryViewConstraints,
      pageViewContraints
    ].map {
      NSLayoutConstraint.activate($0)
    }
  }
}

// MARK: - LayoutSupport Constraints
private extension FavoriteDetailViewController {
  var safeAreaTopBackgroundViewConstraints: [NSLayoutConstraint] {
    return [
      safeAreaTopBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      safeAreaTopBackgroundView.topAnchor.constraint(equalTo: view.topAnchor),
      safeAreaTopBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      safeAreaTopBackgroundView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)]
  }
  
  var categoryViewConstraints: [NSLayoutConstraint] {
    typealias Const = Constant.CategoryView
    return [
      menuView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      menuView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      menuView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      menuView.heightAnchor.constraint(equalToConstant: Const.height)]
  }
  
  var pageViewContraints: [NSLayoutConstraint] {
    pageViewOriginTopAnchor = pageView.topAnchor.constraint(equalTo: menuView.bottomAnchor)
    pageViewTopAnchor = pageViewOriginTopAnchor
    return [
      pageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      pageViewTopAnchor,
      pageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      pageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)]
  }
}
