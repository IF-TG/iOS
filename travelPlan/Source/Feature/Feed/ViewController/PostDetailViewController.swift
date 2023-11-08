//
//  PostDetailViewController.swift
//  travelPlan
//
//  Created by 양승현 on 11/7/23.
//

import UIKit

final class PostDetailViewController: UIViewController {
  private let tableView = UITableView(frame: .zero, style: .grouped).set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.separatorStyle = .none
    $0.rowHeight = UITableView.automaticDimension
    $0.estimatedRowHeight = 235
    $0.separatorInset = .zero
    $0.backgroundColor = .white
    $0.scrollIndicatorInsets = .init(top: 0, left: -1, bottom: 13, right: -1)
    if #available(iOS 15.0, *) {
      $0.sectionHeaderTopPadding = 0
    }
    
    $0.register(
      PostDetailCategoryHeaderView.self,
      forHeaderFooterViewReuseIdentifier: PostDetailCategoryHeaderView.id)
    $0.register(PostDetailTitleCell.self, forCellReuseIdentifier: PostDetailTitleCell.id)
    $0.register(
      PostDetailProfileAreaFooterView.self,
      forHeaderFooterViewReuseIdentifier: PostDetailProfileAreaFooterView.id)
    
    $0.register(PostDetailContentTextCell.self, forCellReuseIdentifier: PostDetailContentTextCell.id)
    $0.register(PostDetailContentImageCell.self, forCellReuseIdentifier: PostDetailContentImageCell.id)
    $0.register(PostDetailContentFooterView.self, forHeaderFooterViewReuseIdentifier: PostDetailContentFooterView.id)
  }
  
  private var adapter: PostDetailTableViewAdapter?
  
  private let viewModel: PostDetailTableViewDataSource
  
  private var prevScrollDirection: UIScrollView.ScrollVerticalDirection = .down
  
  // MARK: - Lifecycle
  init(viewModel: PostDetailTableViewDataSource) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
    adapter = PostDetailTableViewAdapter(
      dataSource: viewModel,
      delegate: self,
      tableView: tableView)
  }
  
  required init?(coder: NSCoder) {
    nil
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
  }
}

// MARK: - Private Helpers
private extension PostDetailViewController {
  func configureUI() {
    view.backgroundColor = .white
    setupUI()
  }
}

// MARK: - PostDetailTableViewDelegate
extension PostDetailViewController: PostDetailTableViewDelegate {
  func willDisplayTitle() {
    guard let topItem = navigationController?.navigationBar.topItem else { return }
    topItem.title = nil
  }
  
  func disappearTitle(_ title: String) {
    guard let topItem = navigationController?.navigationBar.topItem else { return }
    if topItem.title == nil {
      topItem.title = title
    }
  }
}

extension PostDetailViewController: LayoutSupport {
  func addSubviews() {
    view.addSubview(tableView)
  }
  
  func setConstraints() {
    NSLayoutConstraint.activate([
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)])
  }
}
