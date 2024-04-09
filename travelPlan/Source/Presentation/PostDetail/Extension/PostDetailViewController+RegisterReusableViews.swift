//
//  PostDetailViewController+RegisterReusableViews.swift
//  travelPlan
//
//  Created by 양승현 on 4/7/24.
//

import Foundation

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
      PostDetailCommentHeader.self,
      forHeaderFooterViewReuseIdentifier: PostDetailCommentHeader.id)
    tableView.register(
      PostDetailReplyCell.self,
      forCellReuseIdentifier: PostDetailReplyCell.id)
  }
}
