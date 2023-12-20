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
  private let postCollectionView = PostCollectionView().set {
    $0.bounces = false
    $0.showsVerticalScrollIndicator = false
  }
  
  // TODO: - 포스트 뷰모델이 공통속성으로 빠지면, 포스트뷰모델을 상속받아 코어데이터에 저장된 유즈케이스를 갖는 favoriteVM 인스턴스로 재구현해야합니다.
  private let postViewModel: PostViewModel & PostViewAdapterDataSource
  
  private var postAdapter: FavoritePostViewAdapter!
  
  private var subscription: AnyCancellable?
  
  var postUpdatedHandler: ((Int) -> Void)?
  
  weak var delegate: FavoritePostViewDelegate?
  
  // MARK: - Lifecycle
  init(postViewModel: PostViewModel & PostViewAdapterDataSource) {
    self.postViewModel = postViewModel
    super.init(
      contentView: postCollectionView,
      emptyState: .emptyTravelPost)
    postAdapter = FavoritePostViewAdapter(
      dataSource: postViewModel,
      collectionView: postCollectionView)
    postAdapter.delegate = self
    postAdapter.baseDelegate = self
    bind()
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
}

// MARK: - Private Helpers
private extension FavoritePostViewController {
  func bind() {
    subscription = postViewModel.$posts
      .receive(on: DispatchQueue.main)
      .sink { [weak self] in
        self?.hasItem.send($0.count == 0 ? false : true)
        self?.postCollectionView.reloadData()
        self?.postUpdatedHandler?($0.count)
      }
  }
}

// MARK: - PostViewAdapterDelegate
extension FavoritePostViewController: PostViewAdapterDelegate {
  func didTapHeart(in cell: UICollectionViewCell) {
    guard let indexPath = postCollectionView.indexPath(for: cell) else { return }
    print(indexPath)
  }
  
  func didTapComment(in cell: UICollectionViewCell) {
    guard let indexPath = postCollectionView.indexPath(for: cell) else { return }
    print(indexPath)
  }
  
  func didTapShare(in cell: UICollectionViewCell) {
    guard let indexPath = postCollectionView.indexPath(for: cell) else { return }
    print(indexPath)
  }
  
  func didTapOption(in cell: UICollectionViewCell) {
    guard let indexPath = postCollectionView.indexPath(for: cell) else { return }
    print(indexPath)
  }
  
  func didTapPost(with postId: Int) {
    print("특정 포스트 상세 화면으로 이동")
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

// MARK: - FavoriteDetailMenuViewConfigurable
extension FavoritePostViewController: FavoriteDetailMenuViewConfigurable {
  var numberOfItems: Int {
    postViewModel.numberOfItems
  }
}
