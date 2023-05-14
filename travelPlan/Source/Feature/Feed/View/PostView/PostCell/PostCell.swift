//
//  PostViewCell.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/12.
//

import UIKit

final class PostCell: UICollectionViewCell {
  // MARK: - Identifier
  static let id: String = String(describing: PostCell.self)
  
  // MARK: - Properties
  private let headerView = PostHeaderView()
  
  private let contentAreaView = PostContentAreaView()
  
  private let footerView = PostFooterView()
  
  private let line = OneUnitHeightLine(color: .yg.gray0)
  
  var vm: PostCellViewModel!
  
  private override init(frame: CGRect) {
    super.init(frame: .zero)
    backgroundColor = .yg.gray00Background
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Public Helpers
extension PostCell {
  func configure(with post: PostModel) {
    vm = PostCellViewModel(postModel: post)
    setHeaderWithData()
    setContentAreaWithData()
    setFooterWithData()
    configureUI()
  }
}

// MARK: - Helpers
extension PostCell {
  private func configureUI() {
    line.setConstraint(
      fromSuperView: contentView,
      spacing: .init(
        leading: Constant.Line.Spacing.leading,
        trailing: Constant.Line.Spacing.trailing))
  }
  
  private func setHeaderWithData() {
    guard vm.isValidatedHeaderModel() else {
      headerView.configure(with: vm.defaultHeaderModel)
      return
    }
    headerView.configure(with: vm.headerModel)
  }
  
  private func setContentAreaWithData() {
    guard vm.isValidatedContentAreaModel() else {
      contentAreaView.configure(with: vm.defaultContentAreaModel)
      return
    }
    contentAreaView.configure(with: vm.contentAreaModel)
  }
  
  private func setFooterWithData() {
    guard vm.isValidatedFooterModel() else {
      footerView.configure(with: vm.defaultFooterModel)
      return
    }
    footerView.configure(with: vm.footerModel)
  }
}

// MARK: - LayoutSupport
extension PostCell: LayoutSupport {
  func addSubviews() {
    _=[headerView, contentAreaView, footerView].map { contentView.addSubview($0) }
  }
  
  func setConstraints() {
    _=[headViewConstraints,
       contentAreaViewConstraints,
       footerViewConstraints]
      .map { NSLayoutConstraint.activate($0) }
  }
}

// MARK: - LayoutSupport constraints
private extension PostCell {
  var headViewConstraints: [NSLayoutConstraint] {
    [headerView.leadingAnchor.constraint(
      equalTo: contentView.leadingAnchor),
     headerView.topAnchor.constraint(
      equalTo: contentView.topAnchor),
     headerView.trailingAnchor.constraint(
      equalTo: contentView.trailingAnchor),
     headerView.heightAnchor.constraint(equalToConstant: PostHeaderView.Constant.height)]
  }
  
  var contentAreaViewConstraints: [NSLayoutConstraint] {
    [contentAreaView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
     contentAreaView.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor),
     contentAreaView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor)]
  }
  
  var footerViewConstraints: [ NSLayoutConstraint] {
    [footerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
     footerView.trailingAnchor.constraint(
      equalTo: contentView.trailingAnchor),
     footerView.topAnchor.constraint(
      equalTo: contentAreaView.bottomAnchor,
      constant: Constant.FooterView.Spacing.top),
     footerView.bottomAnchor.constraint(
      equalTo: contentView.bottomAnchor,
      constant: -Constant.FooterView.Spacing.bottom)]
  }
}
