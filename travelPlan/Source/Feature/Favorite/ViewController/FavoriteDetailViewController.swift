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
  
  private var pageViewControllerDataSource: [UIViewController]!
  
  // MARK: - Temp
  let postCollectionView = PostCollectionView().set {
    $0.bounces = false
  }
  let postViewModel = PostViewModel(filterInfo: .init(travelTheme: .all, travelTrend: .newest))
  var postAdapter: FavoritePostViewAdapter!
  
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
  
  private var scrollDirection: UIScrollView.ScrollVerticalDirection = .down
  private var targetScrollPosition: CGFloat = 0
  private var categoryViewScrollYPosition: CGFloat = 0
  private var categoryViewVisibleHeight: CGFloat = 0
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
    postAdapter = FavoritePostViewAdapter(
      dataSource: postViewModel,
      delegate: self,
      collectionView: postCollectionView)
  }
}

// MARK: - Private Helpers
private extension FavoriteDetailViewController {
  func configureUI() {
    pageViewControllerDataSource = (0...1).map { i in
      return .init(nibName: nil, bundle: nil).set {
        $0.view.backgroundColor = i == 0 ? .orange : .purple
        if i == 0 {
          $0.view.addSubview(postCollectionView)
          NSLayoutConstraint.activate([
            postCollectionView.leadingAnchor.constraint(equalTo: $0.view.leadingAnchor),
            postCollectionView.topAnchor.constraint(equalTo: $0.view.topAnchor),
            postCollectionView.trailingAnchor.constraint(equalTo: $0.view.trailingAnchor),
            postCollectionView.bottomAnchor.constraint(equalTo: $0.view.bottomAnchor)])
        }
      }
    }
    setupUI()
    view.backgroundColor = .white
  }
  
  func bind() {
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

extension FavoriteDetailViewController: FavoritePostViewAdapterDelegate {
  
  func scrollDidScroll(
    _ scrollView: UIScrollView,
    scrollYPosition: CGFloat,
    direction: UIScrollView.ScrollVerticalDirection
  ) {
//    let targetHeight = Constant.CategoryView.height
    guard isDoneCategoryViewAnimation else { return }
    isDoneCategoryViewAnimation = false
    pageViewTopAnchor.isActive = false
    var targetTransform: CGAffineTransform
    
    if direction == .up {
      pageViewTopAnchor = pageViewOriginTopAnchor
      targetTransform = .identity
    } else {
      pageViewTopAnchor = pageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
      targetTransform = .init(translationX: 0, y: -Constant.CategoryView.height)
    }
    pageViewTopAnchor.isActive = true
    UIView.transition(
      with: categoryView,
      duration: 0.3,
      options: .curveEaseOut,
      animations: {
        self.categoryView.transform = targetTransform
        self.view.layoutIfNeeded()
      }, completion: { _ in
        self.isDoneCategoryViewAnimation = true
      })
  }
  
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView, scrollYPosition: CGFloat) {
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
