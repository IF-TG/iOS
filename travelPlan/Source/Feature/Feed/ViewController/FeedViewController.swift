//
//  FeedViewController.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/05/05.
//

import UIKit

class FeedViewController: UIViewController {
  // MARK: - Properties
  let categoryPageView = CategoryPageView()
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
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
