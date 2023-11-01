//
//  NotificationViewAdapter.swift
//  travelPlan
//
//  Created by 양승현 on 11/1/23.
//

import UIKit

final class NotificationViewAdapter: NSObject {
  // MARK: - Properties
  private let dataSource: NotificationViewAdapterDataSource
  weak var delegate: NotificationViewAdapterDelegate?
  
  // MARK: - Lifecycle
  init(
    dataSource: NotificationViewAdapterDataSource,
    delegate: NotificationViewAdapterDelegate? = nil,
    tableView: UITableView
  ) {
    self.dataSource = dataSource
    self.delegate = delegate
    super.init()
    tableView.dataSource = self
    tableView.delegate = self
  }
}

// MARK: - UITableViewDataSource
extension NotificationViewAdapter: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataSource.numberOfItems
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: NotificationCell.id,
      for: indexPath
    ) as? NotificationCell else {
      return .init(style: .default, reuseIdentifier: NotificationCell.id)
    }
    cell.configure(with: dataSource.getItem(indexPath))
    cell.delegate = self
    return cell
  }
}

// MARK: - UITableViewDelegate
extension NotificationViewAdapter: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
    
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    delegate?.tableView(tableView, didSelectRowAt: indexPath)
  }
}

// MARK: -  BaseNotificationCellDelegate
extension NotificationViewAdapter: BaseNotificationCellDelegate {
  func baseNotificationCell(_ cell: BaseNotificationCell, didTapCloseIcon icon: UIImageView) {
    delegate?.didTapDeleteButton(cell)
  }
}
