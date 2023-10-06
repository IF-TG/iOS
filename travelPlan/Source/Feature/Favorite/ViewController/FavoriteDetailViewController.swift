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
  let postCollectionView = PostCollectionView()
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
  private var pageViewOriginYAnchor: NSLayoutConstraint!
  
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
    let categoryHeight = Constant.CategoryView.height
    
    // 초기에 사라지는 경우
    if direction == .down && scrollYPosition <= categoryHeight {
      categoryViewScrollYPosition = -scrollYPosition
      categoryView.transform = .init(translationX: 0, y: categoryViewScrollYPosition)
      scrollDirection = .down
    }
    
    // 초기, 중간에 업 되는 경우
    if direction == .up, categoryViewScrollYPosition <= 0 {
      if scrollDirection == .down {
        scrollDirection = .up
        targetScrollPosition = scrollYPosition
      }
      let offsetY = targetScrollPosition - scrollYPosition
      if categoryViewScrollYPosition + offsetY >= 0 {
        return
      }
      // categoryViewScrollYPosition += offsetY하면 이게 계속 0.....1씩 감속되는게아니라 중첩되서 1,2,3,6 9 이렇게 빼짐
      categoryView.transform = .init(translationX: 0, y: categoryViewScrollYPosition + offsetY)
    }
    
    // 중간에 다운 되는 경우
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
    pageViewOriginYAnchor = pageView.topAnchor.constraint(equalTo: categoryView.bottomAnchor)
    return [
      pageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      pageViewOriginYAnchor,
      pageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      pageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)]
  }
}
