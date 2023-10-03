//
//  FavoriteTableViewAdapter.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/21.
//

import UIKit

final class FavoriteTableViewAdapter: NSObject {
  
  // MARK: - Properties
  weak var adapterDataSource: FavoriteTableViewAdapterDataSource?
  weak var adapterDelegate: FavoriteTableViewAdapterDelegate?
  
  // MARK: - Initialization
  init(tableView: UITableView,
       adapterDataSource: FavoriteTableViewAdapterDataSource?,
       adapterDelegate: FavoriteTableViewAdapterDelegate?
  ) {
    super.init()
    tableView.delegate = self
    tableView.dataSource = self
    self.adapterDataSource = adapterDataSource
    self.adapterDelegate = adapterDelegate
  }
}

// MARK: - UITableViewDataSource
extension FavoriteTableViewAdapter: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return adapterDataSource?.numberOfItems ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard
      let cell = tableView.dequeueReusableCell(
        withIdentifier: FavoriteTableViewCell.id,
        for: indexPath) as? FavoriteTableViewCell,
      let item = adapterDataSource?.cellItem(at: indexPath.row)
    else {
      return .init()
    }
    cell.configure(with: item)
    return cell
  }
}

// MARK: - UITableViewDelegate
extension FavoriteTableViewAdapter: UITableViewDelegate {
  func tableView(
    _ tableView: UITableView,
    didSelectRowAt indexPath: IndexPath
  ) {
    guard let item = adapterDataSource?.cellItem(at: indexPath.row) else {
      print("DEBUG: Unexpected item fetch error in favorite list tableView adapter's delegate")
      return
    }
    adapterDelegate?.tappedCell(with: item)
  }
  
  func tableView(
    _ tableView: UITableView,
    viewForHeaderInSection section: Int
  ) -> UIView? {
    guard
      let header = tableView.dequeueReusableHeaderFooterView(
      withIdentifier: FavoriteHeaderView.id) as? FavoriteHeaderView,
      let item = adapterDataSource?.headerItem
    else {
      return .init()
    }
    header.configure(with: item)
    return header
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.section == 0 {
      typealias Const = FavoriteTableViewCell.Constant.ImageView
      typealias Spacing = Const.Spacing
      let imageTopSpacing = Spacing.top
      let imageBottomSpacing = Spacing.bottom
      let imageHeight = Const.size.height
      return imageTopSpacing+imageBottomSpacing+imageHeight
    }
    return 0
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    if section == 0 {
      typealias Const = FavoriteHeaderView.Constant.ImageViews
      typealias Spacing = Const.Spacing
      let imageTopSpacing = Spacing.top
      let imageBottomSpacing = Spacing.bottom
      let imageHeight = Const.size.height
      return imageTopSpacing+imageBottomSpacing+imageHeight
    }
    return 0
  }
}
