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
    let contentTextHeight = calculateDynamicLabelHeight(
      fromSuperView: collectionView,
      indexPath)
    return CGSize(
      width: width,
      height: contentTextHeight + PostCell
        .Constant
        .constant
        .intrinsicHeightWithOutContentTextHeight)
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
    
    let text = contentText(indexPath)
    let font = UIFont.init(pretendard: .regular, size: PostContentAreaView.Constant.Text.textSize)!
    let maxSize = CGSize(width: labelWidth, height: 70)
    let options: NSStringDrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]
    let textSize = (text as NSString).boundingRect(
      with: maxSize,
      options: options,
      attributes: [.font: font],
      context: nil
    ).size
    return ceil(textSize.height)
  }
  
  func contentText(_ indexPath: IndexPath) -> String {
    return data[indexPath.row].content.text
  }
}
