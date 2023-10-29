//
//  NotificationViewController.swift
//  travelPlan
//
//  Created by 양승현 on 10/29/23.
//

import UIKit

final class NotificationViewController: UIViewController {
  // MARK: - Properties
  private let tableView = UITableView().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.estimatedRowHeight = 71
    $0.rowHeight = UITableView.automaticDimension
  }
  
  // MARK: - Lifecycle
  override func loadView() {
    view = tableView
  }
}
