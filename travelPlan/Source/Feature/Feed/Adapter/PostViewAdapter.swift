//
//  PostViewAdapter.swift
//  travelPlan
//
//  Created by 양승현 on 2023/07/03.
//

import UIKit

protocol PostViewDataSource: AnyObject {
  var numberOfItems: Int { get }
  func postViewCellItem(at index: Int) -> PostModel
  func contentText(at index: Int) -> String
}

final class PostViewAdapter: NSObject {
  weak var delegateProvider: PostView?
  weak var dataSource: PostViewDataSource?
  init(
    dataSource: PostViewDataSource? = nil,
    collectionView: PostView
  ) {
    super.init()
    self.delegateProvider = collectionView
    self.dataSource = dataSource
    collectionView.dataSource = self
    collectionView.delegate = self
  }
}

// MARK: - UICollectionViewDataSource
extension PostViewAdapter: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return dataSource?.numberOfItems ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard
      let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: PostCell.id,
        for: indexPath
      ) as? PostCell,
      let dataSource = dataSource
    else {
      return .init()
    }
    cell.configure(with: dataSource.postViewCellItem(at: indexPath.row))
    return cell
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    viewForSupplementaryElementOfKind kind: String,
    at indexPath: IndexPath
  ) -> UICollectionReusableView {
    guard
      kind == UICollectionView.elementKindSectionHeader,
      let header = collectionView.dequeueReusableSupplementaryView(
        ofKind: kind,
        withReuseIdentifier: PostViewHeaderCategoryView.id,
        for: indexPath) as? PostViewHeaderCategoryView
    else {
      return .init()
    }
    header.totalViewDelegate = delegateProvider
    header.sortingViewDelegate = delegateProvider
    return header
  }

}
// MARK: - UICollectionViewDelegateFlowLayout
extension PostViewAdapter: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    guard let dataSource = dataSource else { return CGSize(width: 50, height: 50) }
    let width = collectionView.bounds.width
    let labelWidth = collectionView.bounds.width - (
      PostContentAreaView.Constant.Text.Spacing.leading + PostContentAreaView.Constant.Text.Spacing.trailing)
    
    let text = dataSource.contentText(at: indexPath.row)
    let font = UIFont.init(pretendard: .regular, size: PostContentAreaView.Constant.Text.textSize)!
    let maxSize = CGSize(width: labelWidth, height: 70)
    let options: NSStringDrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]
    let textSize = (text as NSString).boundingRect(
      with: maxSize,
      options: options,
      attributes: [.font: font],
      context: nil
    ).size
    let contentTextHeight = ceil(textSize.height)
    
    return CGSize(
      width: width,
      height: contentTextHeight + PostCell
        .Constant
        .constant
        .intrinsicHeightWithOutContentTextHeight)
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    referenceSizeForHeaderInSection section: Int
  ) -> CGSize {
    let screenWidth = collectionView.bounds.width
    return .init(
      width: screenWidth,
      height: PostView.Constant.Header.height)
  }
}
