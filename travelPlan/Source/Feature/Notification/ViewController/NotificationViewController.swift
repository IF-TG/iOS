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
    $0.separatorStyle = .none
    $0.register(NotificationCell.self, forCellReuseIdentifier: NotificationCell.id)
  }
  
  private var adapter: NotificationViewAdapter?
  
  private let viewModel: any NotificationViewModelable
  
  private var subscription: AnyCancellable?
  
  private let input = NotificationViewInput(
    viewDidLoad: .init(),
    didTapCell: .init(),
    didTapDeleteIcon: .init())
    
  // MARK: - Lifecycle
  init(viewModel: any NotificationViewModelable & NotificationViewAdapterDataSource) {
    self.viewModel = viewModel
    super.init(contentView: tableView, emptyState: .emptyNotifiation)
    adapter = .init(
      dataSource: viewModel,
      delegate: self,
      tableView: tableView)
    hasItem.send(true)
    bind()
  }
  
  required init?(coder: NSCoder) {
    nil
  }
}

// MARK: - ViewBindCase
extension NotificationViewController: ViewBindCase {
  typealias Input = NotificationViewInput
  typealias ErrorType = Error
  typealias State = NotificationViewState
  
  func bind() {
    let output = viewModel.transform(input)
    subscription = output.sink { [weak self] in
      self?.render($0)
    }
  }
  
  func render(_ state: NotificationViewState) {
    switch state {
    case .none:
      break
    case .reloadNotifications(let lastItems):
      tableView.reloadData()
      updateHasItem(with: lastItems)
    case .deleteCell(let indexPath, let lastItems):
      tableView.performBatchUpdates {
        tableView.deleteRows(at: [indexPath], with: .fade)
      }
      updateHasItem(with: lastItems)
    case .showDetailPostPage(_):
      // TODO: - 상세 포스트 아이디 기반으로 포스트 상세 화면 가야합니다.
      break
    }
  }
  
  func handleError(_ error: ErrorType) {}
}

// MARK: - Private Helpers
private extension NotificationViewController {
  func updateHasItem(with lastItems: Int) {
    if lastItems == 0 {
      hasItem.send(false)
    } else if hasItem.value != true {
      hasItem.send(true)
    }
  }
}

// MARK: - NotificationViewAdapterDelegate
extension NotificationViewController: NotificationViewAdapterDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    input.didTapCell.send(indexPath.row)
  }
  
  func didTapDeleteButton(_ cell: UITableViewCell) {
    guard let indexPath = tableView.indexPath(for: cell) else { return }
    input.didTapDeleteIcon.send(indexPath)
  }
}
