//
//  PostDetailViewController+RegisterReusableViews.swift
//  travelPlan
//
//  Created by 양승현 on 4/7/24.
//

import UIKit

extension PostDetailViewController {
  func registerReusableViews() {
    tableView.register(
      PostDetailCategoryHeaderView.self,
      forHeaderFooterViewReuseIdentifier: PostDetailCategoryHeaderView.id)
    tableView.register(
      PostDetailTitleCell.self,
      forCellReuseIdentifier: PostDetailTitleCell.id)
    tableView.register(
      PostDetailProfileAreaFooterView.self,
      forHeaderFooterViewReuseIdentifier: PostDetailProfileAreaFooterView.id)
    
    tableView.register(
      PostDetailContentTextCell.self,
      forCellReuseIdentifier: PostDetailContentTextCell.id)
    tableView.register(
      PostDetailContentImageCell.self,
      forCellReuseIdentifier: PostDetailContentImageCell.id)
    tableView.register(
      PostDetailContentFooterView.self,
      forHeaderFooterViewReuseIdentifier: PostDetailContentFooterView.id)
    tableView.register(
      PostHeartAndShareAreaHeaderView.self,
      forHeaderFooterViewReuseIdentifier: PostHeartAndShareAreaHeaderView.id)
    
    tableView.register(
      PostDetailDeletedOrUnknwonCommentHeader.self,
      forHeaderFooterViewReuseIdentifier: PostDetailDeletedOrUnknwonCommentHeader.id)
    tableView.register(
      PostDetailCommentHeader.self,
      forHeaderFooterViewReuseIdentifier: PostDetailCommentHeader.id)
    tableView.register(
      PostDetailReplyCell.self,
      forCellReuseIdentifier: PostDetailReplyCell.id)
  }
  
  func setTableView() {
    tableView.separatorStyle = .none
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 235
    tableView.separatorInset = .zero
    tableView.backgroundColor = .white
    tableView.scrollIndicatorInsets = .init(top: 0, left: -1, bottom: 0, right: -1)
    let minimaiSize = CGSize(width: CGFloat.leastNormalMagnitude, height: CGFloat.leastNormalMagnitude)
    tableView.tableFooterView = UIView(frame: CGRect(origin: .zero, size: minimaiSize))
    tableView.keyboardDismissMode = .interactive
    tableView.contentInset = .zero
    if #available(iOS 15.0, *) {
      tableView.sectionHeaderTopPadding = 0
    }
    let tap = UITapGestureRecognizer(target: self, action: #selector(didTapTableView))
    tableView.addGestureRecognizer(tap)
  }
}
