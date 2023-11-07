//
//  PostDetailTableViewAdapter.swift
//  travelPlan
//
//  Created by 양승현 on 11/7/23.
//

import UIKit

final class PostDetailTableViewAdapter: NSObject {
  // MARK: - Properties
  weak var dataSource: PostDetailTableViewDataSource?
  weak var delegate: PostDetailTableViewDelegate?
  
  // MARK: - Lifecycle
  init(
    dataSource: PostDetailTableViewDataSource?,
    delegate: PostDetailTableViewDelegate?,
    tableView: UITableView
  ) {
    super.init()
    self.dataSource = dataSource
    self.delegate = delegate
    tableView.dataSource = self
  }
}

// MARK: - UITableViewDataSource
extension PostDetailTableViewAdapter: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return dataSource?.numberOfSections ?? 0
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      return dataSource?.numberOfItems(in: section) ?? 0
    default:
      return 0
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let dataSource else { return .init(frame: .zero) }
    switch indexPath.row {
    case 0:
      let postContentItem = dataSource.postContentItem(at: indexPath.row)
      switch postContentItem {
      case .text(let text):
        guard let cell = tableView.dequeueReusableCell(
          withIdentifier: PostDetailContentTextCell.id,
          for: indexPath
        ) as? PostDetailContentTextCell else {
          return .init(frame: .zero)
        }
        cell.configure(with: text)
        return cell
      case .image(let imagePath):
        guard let cell = tableView.dequeueReusableCell(
          withIdentifier: PostDetailContentImageCell.id,
          for: indexPath
        ) as? PostDetailContentImageCell  else {
          return .init(frame: .zero)
        }
        cell.configure(with: imagePath)
        return cell
      }
    default:
      return .init(frame: .zero)
    }
  }
}

// MARK: - UITableViewDelegate
extension PostDetailTableViewAdapter: UITableViewDelegate {
  func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    if section == 0 {
      return tableView.dequeueReusableHeaderFooterView(withIdentifier: PostDetailContentFooterView.id) 
    }
    return nil
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
  
  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return section == 0 ? 11 : 0
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    delegate?.scrollViewDidScroll(scrollView)
  }
}
