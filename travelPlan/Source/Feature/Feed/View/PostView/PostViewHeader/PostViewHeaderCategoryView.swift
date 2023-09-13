//
//  PostDetailCategoryHeaderView.swift
//  travelPlan
//
//  Created by 양승현 on 2023/07/03.
//

import UIKit

final class PostViewHeaderCategoryView: UICollectionReusableView {
  
  // MARK: - Identifier
  static let id: String = String(describing: PostCell.self)
  
  // MARK: - Properties
  private let totalView = MoreCategoryView().set {
    $0.configure(with: .trend)
  }
  
  private let sortingView = MoreCategoryView().set {
    $0.configure(with: .detailCategory)
  }
  
  var totalViewDelegate: MoreCategoryViewDelegate? {
    get {
      totalView.delegate
    }
    set {
      totalView.delegate = newValue
    }
  }
  
  var sortingViewDelegate: MoreCategoryViewDelegate? {
    get {
      sortingView.delegate
    }
    set {
      sortingView.delegate = newValue
    }
  }
  
  // MARK: - LifeCycle
  private override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  
  required init?(coder: NSCoder) { fatalError() }
  
  convenience init() {
    self.init(frame: .zero)
  }
}

// MARK: - LayoutSupport
extension PostViewHeaderCategoryView: LayoutSupport {
  func addSubviews() {
    _=[totalView, sortingView].map { addSubview($0) }
  }
  
  func setConstraints() {
    _=[totalViewConstraints, sortingViewConstraints].map { NSLayoutConstraint.activate($0) }
  }
}

// MARK: - Layout support helper
private extension PostViewHeaderCategoryView {
  var totalViewConstraints: [NSLayoutConstraint] {
    [totalView.leadingAnchor.constraint(
      equalTo: leadingAnchor,
      constant: Constant.TotalView.spacing.leading),
     totalView.topAnchor.constraint(
      equalTo: topAnchor,
      constant: Constant.TotalView.spacing.top),
     totalView.bottomAnchor.constraint(
      equalTo: bottomAnchor,
      constant: 0)]
  }
  
  var sortingViewConstraints: [NSLayoutConstraint] {
    [sortingView.leadingAnchor.constraint(
      equalTo: totalView.trailingAnchor,
      constant: Constant.SortingView.spacing.leading),
     sortingView.topAnchor.constraint(
      equalTo: topAnchor,
      constant: Constant.SortingView.spacing.top),
     sortingView.bottomAnchor.constraint(
      equalTo: bottomAnchor,
      constant: 0)
    ]
  }
}
