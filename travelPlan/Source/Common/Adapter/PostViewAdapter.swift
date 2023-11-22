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
    if indexPath.section == 1, let thumbnails = dataSource?.numberOfThumbnailsInPost(at: indexPath.row) {
      guard let postItem = dataSource?.postItem(at: indexPath.row) else { return .init() }
      switch thumbnails {
      case 1:
        guard let cell = collectionView.dequeueReusableCell(
          withReuseIdentifier: PostCellWithOneThumbnail.id, for: indexPath
        ) as? PostCellWithOneThumbnail else { return .init() }
        cell.configure(with: postItem)
        checkLastCell(cell, indexPath: indexPath)
        return cell
      case 2:
        guard let cell = collectionView.dequeueReusableCell(
          withReuseIdentifier: PostCellWithTwoThumbnails.id, for: indexPath
        ) as? PostCellWithTwoThumbnails else { return .init(frame: .zero) }
        cell.configure(with: postItem)
        checkLastCell(cell, indexPath: indexPath)
        return cell
      case 3:
        guard let cell = collectionView.dequeueReusableCell(
          withReuseIdentifier: PostCellWithThreeThumbnails.id, for: indexPath
        ) as? PostCellWithThreeThumbnails else { return .init(frame: .zero) }
        cell.configure(with: postItem)
        checkLastCell(cell, indexPath: indexPath)
        return cell
      case 4:
        guard let cell = collectionView.dequeueReusableCell(
          withReuseIdentifier: PostCellWithFourThumbnails.id, for: indexPath
        ) as? PostCellWithFourThumbnails else { return .init(frame: .zero) }
        cell.configure(with: postItem)
        checkLastCell(cell, indexPath: indexPath)
        return cell
      case 5:
        guard let cell = collectionView.dequeueReusableCell(
          withReuseIdentifier: PostCellWithFiveThumbnails.id, for: indexPath
        ) as? PostCellWithFiveThumbnails else { return .init(frame: .zero) }
        cell.configure(with: postItem)
        checkLastCell(cell, indexPath: indexPath)
        return cell
      default:
        return .init(frame: .zero)
      }
    }
    return .init(frame: .zero)
  }
}

// MARK: - Private helper
private extension PostViewAdapter {
  func checkLastCell(_ cell: UICollectionViewCell & PostCellEdgeDividable, indexPath: IndexPath) {
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
