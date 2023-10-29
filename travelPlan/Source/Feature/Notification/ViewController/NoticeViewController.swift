//
//  NoticeViewController.swift
//  travelPlan
//
//  Created by 양승현 on 10/29/23.
//

import UIKit

final class NoticeViewController: UIViewController {
  // MARK: - Properties
  private let tableView = UITableView().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.estimatedRowHeight = 91
    $0.rowHeight = UITableView.automaticDimension
    $0.register(NoticeCell.self, forCellReuseIdentifier: NoticeCell.id)
    $0.separatorStyle = .none
  }
  
  private var adapter: NoticeViewAdapter?
  
  private let viewModel: NoticeViewAdapterDataSource
    
  // MARK: - Lifecycle
  init(viewModel: NoticeViewAdapterDataSource) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
    adapter = NoticeViewAdapter(dataSource: viewModel, tableView: tableView)
    adapter?.delegate = self
  }
  
  required init?(coder: NSCoder) {
    nil
  }
  
  override func loadView() {
    view = tableView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
}

// MARK: - NoticeViewAdapterDelegate
extension NoticeViewController: NoticeViewAdapterDelegate {
  func noticeViewAdapter(
    _ noticeViewAdapter: NoticeViewAdapter,
    didSelectRowAt indexPath: IndexPath,
    isExpended: Bool
  ) {
    // TODO: - input전송
  }
}
