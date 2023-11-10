//
//  PostViewAdapter.swift
//  travelPlan
//
//  Created by 양승현 on 2023/07/03.
//

import UIKit

class PostViewAdapter: NSObject {
  weak var dataSource: PostViewAdapterDataSource?
  weak var baseDelegate: PostViewAdapterDelegate?
  init(
    dataSource: PostViewAdapterDataSource? = nil,
    delegate: PostViewAdapterDelegate? = nil,
    collectionView: UICollectionView?
  ) {
    super.init()
    self.dataSource = dataSource
    self.baseDelegate = delegate
    collectionView?.dataSource = self
    collectionView?.delegate = self
  }
}

// MARK: - UICollectionViewDataSource
extension PostViewAdapter: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 2
  }
  
  func collectionView(
    _ collectionView: UICollectionView, 
    numberOfItemsInSection section: Int
  ) -> Int {
    if section == 1, let numberOfItems = dataSource?.numberOfItems {
      return numberOfItems
    }
    return 0
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    if indexPath.section == 1 {
      guard
        let cell = collectionView.dequeueReusableCell(
          withReuseIdentifier: PostCell.id,
          for: indexPath
        ) as? PostCell,
        let dataSource = dataSource
      else {
        return .init(frame: .zero)
      }
      cell.configure(with: dataSource.postItem(at: indexPath.row))
      checkLastCell(cell, indexPath: indexPath)
      return cell
    }
    return .init(frame: .zero)
  }
}

// MARK: - Private helper
private extension PostViewAdapter {
  func checkLastCell(_ cell: PostCell, indexPath: IndexPath) {
    if let numberOfItems = dataSource?.numberOfItems, indexPath.item == numberOfItems - 1 {
      cell.hideCellDivider()
    }
  }
}

// MARK: - UICollectionViewDelegate
extension PostViewAdapter: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let dataSource else { return }
    baseDelegate?.didTapPost(with: dataSource.postItem(at: indexPath.row).postId)
  }
}
