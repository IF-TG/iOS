//
//  FeedViewController.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/05/05.
//

import UIKit

class FeedViewController: UIViewController {
  // MARK: - Properties
  private let categoryPageView = CategoryPageView()
  
  private let feedNavigationBar = FeedNavigationBar()
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
  }
}

// MARK: - Helpers
extension FeedViewController {
  private func configureUI() {
    setupUI()
    navigationController?.navigationBar.backgroundColor = .white
    view.backgroundColor = .white
    guard let naviBar = navigationController?.navigationBar else { return }
    feedNavigationBar.delegate = self
    feedNavigationBar.layoutFrom(naviBar)
  }
}

extension FeedViewController: FeedNavigationBarDelegate {
  func didTapUserPostSearch() {
    // goto user post search naivgationController
    print("DEBUG: User post search event occured")
  }

  func didTapNotification() {
    // goto notifiation with naivgationController
    print("DEBUG: User notification event occured")
  }

}

// MARK: - LayoutSupport
extension FeedViewController: LayoutSupport {
  func addSubviews() {
    view.addSubview(categoryPageView)
  }

  func setConstraints() {
    NSLayoutConstraint.activate(categoryPageViewConstraint)
  }
}

fileprivate extension FeedViewController {
  var categoryPageViewConstraint: [NSLayoutConstraint] {
    [categoryPageView.topAnchor.constraint(
      equalTo: view.safeAreaLayoutGuide.topAnchor),
     categoryPageView.leadingAnchor.constraint(
      equalTo: view.leadingAnchor),
     categoryPageView.trailingAnchor.constraint(
      equalTo: view.trailingAnchor),
     categoryPageView.bottomAnchor.constraint(
      equalTo: view.safeAreaLayoutGuide.bottomAnchor)]
  }
}
