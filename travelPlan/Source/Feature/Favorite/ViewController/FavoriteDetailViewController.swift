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
  private let categoryView = FavoriteDetailCategoryAreaView()
  
  private var pageViewControllerDataSource: [UIViewController]!
  
  // MARK: - Temp
  let postCollectionView = PostCollectionView()
  let postViewModel = PostViewModel(filterInfo: .init(travelTheme: .all, travelTrend: .newest))
  lazy var postAdapter = PostViewAdapter(
    dataSource: postViewModel,
    collectionView: postCollectionView)
  
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
    pageViewControllerDataSource = (0...1).map { i in
      return .init(nibName: nil, bundle: nil).set {
        $0.view.backgroundColor = i == 0 ? .orange : .purple
        if i == 0 {
          $0.view.addSubview(postCollectionView)
          postCollectionView.translatesAutoresizingMaskIntoConstraints = true
          postCollectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        }
      }
    }
    setupUI()
    view.backgroundColor = .white
  }
  
  func bind() {
    categoryView.travelReviewTapHandler = {
      print("무야호")
      self.pageViewController.setViewControllers(
        [self.pageViewControllerDataSource[0]],
        direction: .forward,
        animated: true)
      
      return 3
    }
    
    categoryView.travelLocationTapHandler = {
      print("무야호222")
      self.pageViewController.setViewControllers(
        [self.pageViewControllerDataSource[1]],
        direction: .reverse,
        animated: true)
      return 2
    }
  }
}

// MARK: - LayoutSupport
extension FavoriteDetailViewController: LayoutSupport {
  func addSubviews() {
    _=[
      categoryView,
      pageView
    ].map {
      view.addSubview($0)
    }
  }
  
  func setConstraints() {
    _=[
      categoryViewConstraints,
      pageViewContraints
    ].map {
      NSLayoutConstraint.activate($0)
    }
  }
}

// MARK: - LayoutSupport Constraints
private extension FavoriteDetailViewController {
  var categoryViewConstraints: [NSLayoutConstraint] {
    typealias Const = Constant.CategoryView
    return [
      categoryView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      categoryView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      categoryView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      categoryView.heightAnchor.constraint(equalToConstant: Const.height)]
  }
  
  var pageViewContraints: [NSLayoutConstraint] {
    return [
      pageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      pageView.topAnchor.constraint(equalTo: categoryView.bottomAnchor),
      pageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      pageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)]
  }
}
