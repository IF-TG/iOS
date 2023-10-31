//
//  NotificationViewController.swift
//  travelPlan
//
//  Created by 양승현 on 10/29/23.
//

import UIKit
import Combine

final class NotificationViewController: EmptyStateBasedContentViewController {
  // MARK: - Properties
  private let tableView = UITableView().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.estimatedRowHeight = 71
    $0.rowHeight = UITableView.automaticDimension
  }
    
  // MARK: - Lifecycle
  init() {
    super.init(contentView: tableView, emptyState: .emptyNotifiation)
    hasItem.send(false)
  }
  
  required init?(coder: NSCoder) {
    nil
  }
}

// MARK: - Private Helpers
private extension NotificationViewController {
  func bind() {}
}
