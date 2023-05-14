//
//  PostViewModel.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/14.
//

import UIKit

struct PostViewModel {
  // MARK: - Properties
  private let data: [PostModel]
  
    var count: Int {
      data.count
    }
  
  // MARK: - Properteis
  init(data: [PostModel]) {
    self.data = data
  }
}

// MARK: - Public helpers
extension PostViewModel {
  func cellItem(_ indexPath: IndexPath) -> PostModel {
    return data[indexPath.row]
  }
  
  func calculatePostCellWidthAndDynamicHeight(
    fromSuperView collectionView: UICollectionView,
    _ indexPath: IndexPath
  ) -> CGSize {
    let width = collectionView.bounds.width
    let postHeaderViewHeight = PostHeaderView.Constant.height
    let postContentImageAreaHeight = PostContentAreaView.Constant.ImageSpacing
      .top + PostContentAreaView.Constant.imageHeight
    let postContentTextAreaHeight = PostContentAreaView.Constant.Text.Spacing
      .top + calculateDynamicLabelHeight(
        fromSuperView: collectionView,
        indexPath) + PostContentAreaView.Constant.Text.Spacing.bottom
    let postFooterViewHeight = PostFooterView.Constant.footerViewheight
    return CGSize(
      width: width,
      height: postHeaderViewHeight + postContentImageAreaHeight +
      postContentTextAreaHeight + postFooterViewHeight)
  }
}

// MARK: - Helpers
private extension PostViewModel {
  func calculateDynamicLabelHeight(
    fromSuperView collectionView: UICollectionView,
    _ indexPath: IndexPath
  ) -> CGFloat {
    let labelWidth = collectionView.bounds.width - (
      PostContentAreaView.Constant.Text.Spacing.leading + PostContentAreaView.Constant.Text.Spacing.trailing)
    let label = UILabel(frame: CGRect(x: 0, y: 0, width: labelWidth, height: 1))
    label.numberOfLines = 3
    label.font = UIFont.systemFont(
      ofSize: PostContentAreaView.Constant.Text.textSize)
    label.lineBreakMode = PostContentAreaView
      .Constant.Text.lineBreakMode
    label.text = self.cellItem(indexPath).content.text
    label.sizeToFit()
    return label.bounds.height
  }
}
