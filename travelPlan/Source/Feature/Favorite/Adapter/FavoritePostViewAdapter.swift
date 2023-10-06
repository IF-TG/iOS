//
//  FavoriteReviewContentAdapter.swift
//  travelPlan
//
//  Created by 양승현 on 10/6/23.
//

import UIKit

final class FavoritePostViewAdapter: PostViewAdapter {
  private var scrollPosition: CGFloat = 0
  
  weak var delegate: FavoritePostViewAdapterDelegate?
  
  init(
    dataSource: PostViewAdapterDataSource?,
    delegate: FavoritePostViewAdapterDelegate?,
    collectionView: PostCollectionView?
  ) {
    self.delegate = delegate
    super.init(dataSource: dataSource, collectionView: collectionView)
    collectionView?.delegate = self
  }
}

extension FavoritePostViewAdapter: UICollectionViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    guard scrollView.contentOffset.y >= 0 else {
      return
    }
    var direction: UIScrollView.ScrollVerticalDirection
    let scrollYPosition = scrollView.contentOffset.y
    direction = scrollPosition < scrollYPosition ? .down : .up
    scrollPosition = scrollYPosition
    delegate?.scrollDidScroll(scrollView, scrollYPosition: scrollYPosition, direction: direction)
  }
  
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    delegate?.scrollViewDidEndDecelerating(scrollView, scrollYPosition: scrollView.contentOffset.y)
  }
}
