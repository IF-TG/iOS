//
//  PostDetailViewController+RegisterReusableViews.swift
//  travelPlan
//
//  Created by 양승현 on 4/7/24.
//

import UIKit

extension PostDetailViewController {
  func registerReusableViews() {
    tableView.register(type: PostDetailCategoryHeaderView.self)
    tableView.register(type: PostDetailTitleCell.self)
    tableView.register(type: PostDetailProfileAreaFooterView.self)
    tableView.register(type: PostDetailContentTextCell.self)
    tableView.register(type: PostDetailContentImageCell.self)
    tableView.register(type: PostDetailContentFooterView.self)
    tableView.register(type: PostHeartAndShareAreaHeaderView.self)
    tableView.register(type: PostDetailDeletedOrUnknwonCommentHeader.self)
    tableView.register(type: PostDetailCommentHeader.self)
    tableView.register(type: PostDetailReplyCell.self)
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
