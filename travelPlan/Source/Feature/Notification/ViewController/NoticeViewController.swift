//
//  NoticeViewController.swift
//  travelPlan
//
//  Created by 양승현 on 10/29/23.
//

import UIKit
import Combine

struct NoticeViewInput {
  var viewDidLoad: PassthroughSubject<Void, Never> = .init()
  var didTapNotice: PassthroughSubject<(indexPath: IndexPath, isExpected: Bool), Never> = .init()
}

enum NoticeViewState {
  case none
  case updateNotices
}

final class NoticeViewController: UIViewController {
  // MARK: - Properties
  private let tableView = UITableView().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.estimatedRowHeight = 91
    $0.rowHeight = UITableView.automaticDimension
    $0.register(NoticeCell.self, forCellReuseIdentifier: NoticeCell.id)
    $0.separatorStyle = .none
  }
  
  private let input = NoticeViewInput()
  
  private var adapter: NoticeViewAdapter?
  
  private let viewModel: any NoticeViewModelable
  
  private var subscriptions = Set<AnyCancellable>()
    
  // MARK: - Lifecycle
  init(viewModel: any NoticeViewModelable & NoticeViewAdapterDataSource) {
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
    bind()
    input.viewDidLoad.send()
  }
}

// MARK: - ViewBindCase
extension NoticeViewController: ViewBindCase {
  typealias Input = NoticeViewInput
  typealias ErrorType = Error
  typealias State = NoticeViewState
  
  func bind() {
    let output = viewModel.transform(input)
    output.receive(on: DispatchQueue.main).sink { [weak self] in
      self?.render($0)
    }.store(in: &subscriptions)
  }
  
  func render(_ state: NoticeViewState) {
    switch state {
    case .none:
      break
    case .updateNotices:
      tableView.reloadData()
    }
  }
  
  func handleError(_ error: ErrorType) {}
}

// MARK: - NoticeViewAdapterDelegate
extension NoticeViewController: NoticeViewAdapterDelegate {
  func noticeViewAdapter(
    _ noticeViewAdapter: NoticeViewAdapter,
    didSelectRowAt indexPath: IndexPath,
    isExpended: Bool
  ) {
    input.didTapNotice.send((indexPath, isExpended))
  }
}
