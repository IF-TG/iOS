//
//  FavoriteTableView.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/20.
//

import UIKit

final class FavoriteTableView: UITableView {
  // MARK: - Constant
  static let innerGrayLineHeight = 0.5
  
  // MARK: - Initialization
  private override init(frame: CGRect, style: UITableView.Style) {
    super.init(frame: frame, style: style)
    configureUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  convenience init() {
    self.init(frame: .zero)
  }
}

// MARK: - Helpers
extension FavoriteTableView {
  func layoutFrom(superView: UIView) {
      superView.addSubview(self)
    superView.layoutIfNeeded()
    NSLayoutConstraint.activate([
      leadingAnchor.constraint(
        equalTo: superView.leadingAnchor),
      topAnchor.constraint(
        equalTo: superView.safeAreaLayoutGuide.topAnchor),
      trailingAnchor.constraint(
        equalTo: superView.trailingAnchor),
      bottomAnchor.constraint(
        equalTo: superView.safeAreaLayoutGuide.bottomAnchor)])
  }
}

// MARK: - Private helpers
private extension FavoriteTableView {
  func configureUI() {
    translatesAutoresizingMaskIntoConstraints = false
    if #available(iOS 15.0, *) {
      sectionHeaderTopPadding = 0
    }
    separatorStyle = .none
    register(
      FavoriteTableViewCell.self,
      forCellReuseIdentifier: FavoriteTableViewCell.id)
    register(
      FavoriteHeaderView.self,
      forHeaderFooterViewReuseIdentifier: FavoriteHeaderView.id)
  }
}
