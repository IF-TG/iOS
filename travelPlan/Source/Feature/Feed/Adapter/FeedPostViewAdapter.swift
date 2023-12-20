//
//  FeedPostViewAdapter.swift
//  travelPlan
//
//  Created by 양승현 on 10/22/23.
//

import UIKit

final class FeedPostViewAdapter: PostViewAdapter {
  // MARK: - Properties
  private weak var feedDataSource: FeedPostViewAdapterDataSource?
  
  // MARK: - Lifecycle
  init(
    dataSource: FeedPostViewAdapterDataSource?,
    collectionView: UICollectionView?
  ) {
    feedDataSource = dataSource
    super.init(dataSource: dataSource, collectionView: collectionView)
  }
}

// MARK: - UICollectionViewDelegate
extension FeedPostViewAdapter {
  func collectionView(
    _ collectionView: UICollectionView,
    viewForSupplementaryElementOfKind kind: String,
    at indexPath: IndexPath
  ) -> UICollectionReusableView {
    if kind == UICollectionView.elementKindSectionHeader, indexPath.section == 0 {
      guard
        let dataSource = feedDataSource,
        let header = collectionView.dequeueReusableSupplementaryView(
        ofKind: UICollectionView.elementKindSectionHeader,
        withReuseIdentifier: PostSortingAreaView.id,
        for: indexPath
      ) as? PostSortingAreaView else { return .init(frame: .zero) }
      header.configure(with: dataSource.headerItem)
      return header
    }
    return .init(frame: .zero)
  }
}
