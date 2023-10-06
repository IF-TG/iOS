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
  }
  
  // MARK: - Properties
  private let safeAreaTopBackgroundView = UIView(frame: .zero).set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = .systemPink
  }
  
  private let categoryView = FavoriteDetailCategoryAreaView()
  
  // TODO: - 장소 찜 화면 나오면 그 떄 EmptyStateBasedContentViewController타입으로 변경.
  private var pageViewControllerDataSource: [UIViewController]!
  
  private lazy var pageViewController = UIPageViewController(
    transitionStyle: .scroll,
    navigationOrientation: .horizontal
  ).set {
    $0.view.translatesAutoresizingMaskIntoConstraints = false
    $0.setViewControllers(
      [pageViewControllerDataSource[0]],
      direction: .forward,
      animated: true)
  }
  
  private var pageView: UIView! {
    pageViewController.view
  }
  
  private var categoryViewTargetTransform = CGAffineTransform()
  
  private var pageViewOriginTopAnchor: NSLayoutConstraint!
  
  private var pageViewTopAnchor: NSLayoutConstraint!
  
  private var isDoneCategoryViewAnimation = true
  
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
}

// MARK: - Private Helpers
private extension FavoriteDetailViewController {
  func configureUI() {
    let favoritePostReviewViewController = FavoritePostViewController().set {
      $0.delegate = self
    }
    let tempFavoriteLocationViewController = UIViewController().set { 
      $0.view.backgroundColor = .orange
    }
    pageViewControllerDataSource = [favoritePostReviewViewController, tempFavoriteLocationViewController]
    view.backgroundColor = .white
    setupUI()
  }
  
  func bind() {
    // TODO: - 이거 이제 페이보릿 포스트 리뷰 뷰컨의 뷰모델 꺼로 동기화 해야함.
    categoryView.travelReviewTapHandler = {
      self.pageViewController.setViewControllers(
        [self.pageViewControllerDataSource[0]],
        direction: .reverse,
        animated: true)
      return 3
    }
    
    categoryView.travelLocationTapHandler = {
      self.pageViewController.setViewControllers(
        [self.pageViewControllerDataSource[1]],
        direction: .forward,
        animated: true)
      return 2
    }
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
      with: categoryView,
      duration: 0.3,
      options: .curveEaseOut,
      animations: {
        self.categoryView.transform = self.categoryViewTargetTransform
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
      categoryView,
      safeAreaTopBackgroundView,
      pageView
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
      categoryView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      categoryView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      categoryView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      categoryView.heightAnchor.constraint(equalToConstant: Const.height)]
  }
  
  var pageViewContraints: [NSLayoutConstraint] {
    pageViewOriginTopAnchor = pageView.topAnchor.constraint(equalTo: categoryView.bottomAnchor)
    pageViewTopAnchor = pageViewOriginTopAnchor
    return [
      pageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      pageViewTopAnchor,
      pageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      pageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)]
  }
}
