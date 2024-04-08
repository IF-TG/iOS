//
//  PostDetailCategoryViewController.swift
//  travelPlan
//
//  Created by 양승현 on 4/8/24.
//

import UIKit

final class PostDetailCategoryViewController: UITableViewController {
  // MARK: - Properties
  private let dataSource: [String]
  
  // MARK: - Lifecycle
  init(style: UITableView.Style, dataSource: [String]) {
    self.dataSource = dataSource
    super.init(style: style)
    let categoryCellNib = UINib(nibName: "PostDetailCategoryCell", bundle: nil)
    tableView.register(categoryCellNib, forCellReuseIdentifier: "PostDetailCategoryCell")
    setupDefaultBackBarButtonItem(marginLeft: 0)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - UITableViewDataSource
extension PostDetailCategoryViewController {
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 0 {
      return dataSource.count
    }
    return 0
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.section == 0 {
      guard
        let cell = tableView.dequeueReusableCell(
          withIdentifier: "PostDetailCategoryCell",
          for: indexPath) as? PostDetailCategoryCell
      else { return .init() }
      cell.configure(with: dataSource[indexPath.row])
      return cell
    }
    return .init()
  }
}
