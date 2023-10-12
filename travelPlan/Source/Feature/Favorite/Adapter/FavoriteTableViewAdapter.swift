//
//  FavoriteTableViewAdapter.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/21.
//

import UIKit

final class FavoriteTableViewAdapter: NSObject {
  
  // MARK: - Properties
  weak var dataSource: FavoriteTableViewAdapterDataSource?
  weak var delegate: FavoriteTableViewAdapterDelegate?
  
  // MARK: - Initialization
  init(tableView: UITableView,
       dataSource: FavoriteTableViewAdapterDataSource?,
       delegate: FavoriteTableViewAdapterDelegate?
  ) {
    super.init()
    tableView.delegate = self
    tableView.dataSource = self
    self.dataSource = dataSource
    self.delegate = delegate
  }
}

// MARK: - UITableViewDataSource
extension FavoriteTableViewAdapter: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataSource?.numberOfItems ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard
      let cell = tableView.dequeueReusableCell(
        withIdentifier: FavoriteTableViewCell.id,
        for: indexPath) as? FavoriteTableViewCell,
      let item = dataSource?.cellItem(at: indexPath.row)
    else {
      return .init()
    }
    cell.configure(with: item)
    cell.delegate = self
    return cell
  }
}

// MARK: - UITableViewDelegate
extension FavoriteTableViewAdapter: UITableViewDelegate {
  func tableView(
    _ tableView: UITableView,
    didSelectRowAt indexPath: IndexPath
  ) {
    delegate?.tableView(tableView, didSelectRowAt: indexPath)
  }
  
  func tableView(
    _ tableView: UITableView,
    viewForHeaderInSection section: Int
  ) -> UIView? {
    guard
      let item = dataSource?.headerItem,
      let header = tableView.dequeueReusableHeaderFooterView(
        withIdentifier: FavoriteHeaderView.id
      ) as? FavoriteHeaderView
    else {
      return .init()
    }
    header.configure(with: item)
    return header
  }
}

// MARK: - FavoriteTableViewCellDelegate
extension FavoriteTableViewAdapter: FavoriteTableViewCellDelegate {
  func favoriteTableViewCell(_ cell: UITableViewCell, touchUpEditModeTitleLabel label: UILabel) {
    delegate?.tableViewCell(cell, didTapEditModeTitle: label.text)
  }
  
  func favoriteTableViewCell(_ cell: UITableViewCell, touchUpDeleteButton button: UIButton) {
    delegate?.tableViewCell(cell, didtapDeleteButton: button)
  }
}
