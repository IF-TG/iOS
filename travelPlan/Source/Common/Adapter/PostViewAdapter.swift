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
    guard
      indexPath.section == 1,
      let numberOfThumbnails = dataSource?.numberOfThumbnailsInPost(at: indexPath.row),
      let postItem = dataSource?.postItem(at: indexPath.row) 
    else { return .init(frame: .zero) }
    let cell = makePostCell(collectionView, cellForItemAt: indexPath, with: numberOfThumbnails)
    cell?.configure(with: postItem)
    checkLastCell(cell, indexPath: indexPath)
    return cell ?? .init(frame: .zero)
  }
}

// MARK: - Private helper
private extension PostViewAdapter {
  func checkLastCell(_ cell: (PostCellEdgeDividable)?, indexPath: IndexPath) {
    if let numberOfItems = dataSource?.numberOfItems, indexPath.item == numberOfItems - 1 {
      cell?.hideCellDivider()
    }
  }
  
  func makePostCell(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath,
    with numberOfThumbnails: PostThumbnailCountValue
  ) -> (any UICollectionViewCell & PostCellConfigurable & PostCellEdgeDividable)? {
    switch numberOfThumbnails {
    case .one:
      return collectionView.dequeueReusableCell(
        withReuseIdentifier: PostCellWithOneThumbnail.id, for: indexPath
      ) as? PostCellWithOneThumbnail
    case .two:
      return collectionView.dequeueReusableCell(
        withReuseIdentifier: PostCellWithTwoThumbnails.id, for: indexPath
      ) as? PostCellWithTwoThumbnails
    case .three:
      return collectionView.dequeueReusableCell(
        withReuseIdentifier: PostCellWithThreeThumbnails.id, for: indexPath
      ) as? PostCellWithThreeThumbnails
    case .four:
      return collectionView.dequeueReusableCell(
        withReuseIdentifier: PostCellWithFourThumbnails.id, for: indexPath
      ) as? PostCellWithFourThumbnails
    case .five:
      return collectionView.dequeueReusableCell(
        withReuseIdentifier: PostCellWithFiveThumbnails.id, for: indexPath
      ) as? PostCellWithFiveThumbnails
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
