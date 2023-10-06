//
//  FavoritePostViewController.swift
//  travelPlan
//
//  Created by 양승현 on 10/6/23.
//

import UIKit
import Combine

final class FavoritePostViewController: EmptyStateBasedContentViewController {
  // MARK: - Properties
  private let postCollectionView = FavoritePostCollectionView()
  
  // TODO: - 포스트 뷰모델이 공통속성으로 빠지면, 포스트뷰모델을 상속받아 코어데이터에 저장된 유즈케이스를 갖는 인스턴스로 재구현해야합니다.
  private let postViewModel = PostViewModel(filterInfo: .init(travelTheme: .all, travelTrend: .newest))
  
  private var postAdapter: FavoritePostViewAdapter!
  
  weak var delegate: FavoritePostViewDelegate?
  
  // MARK: - Lifecycle
  init() {
    super.init(
      contentView: postCollectionView,
      emptyState: .emptyTravelPost)
    postAdapter = FavoritePostViewAdapter(
      dataSource: postViewModel,
      delegate: self,
      collectionView: postCollectionView)
    bind()
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
}

// MARK: - Private Helpers
private extension FavoritePostViewController {
  func bind() {
    postCollectionView.hasItem.send(postViewModel.numberOfItems > 0 ? true : false)
  }
}

// MARK: - FavoritePostViewAdapterDelegate
extension FavoritePostViewController: FavoritePostViewAdapterDelegate {
  func scrollDidScroll(
    _ scrollView: UIScrollView,
    scrollYPosition: CGFloat,
    direction: UIScrollView.ScrollVerticalDirection
  ) {
    delegate?.scrollDidScroll(scrollView, scrollYPosition: scrollYPosition, direction: direction)
  }
}
