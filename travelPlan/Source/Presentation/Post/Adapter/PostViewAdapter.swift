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
  
  private var isPaging: Bool { dataSource?.isPaging ?? false }
  private var hasMorePages: Bool { dataSource?.hasMorePages ?? false }
  
  init(
    dataSource: PostViewAdapterDataSource? = nil,
    collectionView: UICollectionView?
  ) {
    super.init()
    self.dataSource = dataSource
    collectionView?.dataSource = self
    collectionView?.delegate = self
  }
}

// MARK: - UICollectionViewDataSource
extension PostViewAdapter: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return PostViewSection.count
  }
  
  func collectionView(
    _ collectionView: UICollectionView, 
    numberOfItemsInSection section: Int
  ) -> Int {
    let postSection = PostViewSection(rawValue: section)
    return switch postSection {
    case .category:
      0
    case .post:
      dataSource?.numberOfItems ?? 0
    case .bottomRefresh:
      isPaging && hasMorePages ? 1 : 0
    default:
      0
    }
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    let postSection = PostViewSection(rawValue: indexPath.section)
    if postSection == .post {
      guard let numberOfThumbnails = dataSource?.numberOfThumbnailsInPost(at: indexPath.row),
        let postItem = dataSource?.postItem(at: indexPath.row)
      else { return .init(frame: .zero) }
      let cell = makePostCell(collectionView, cellForItemAt: indexPath, with: numberOfThumbnails)
      cell?.configure(with: postItem)
      checkLastCell(cell, indexPath: indexPath)
      return cell ?? .init(frame: .zero)
    }
    if postSection == .bottomRefresh {
      guard let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: BottomNextPageIndicatorCell.identifier,
        for: indexPath
      ) as? BottomNextPageIndicatorCell else {
        return .init(frame: .zero)
      }
      cell.startIndicator()
      return cell
    }
    return .init(frame: .zero)
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let offsetY = scrollView.contentOffset.y
    let contentHeight = scrollView.contentSize.height
    let scrollViewHeight = scrollView.frame.height
    let scrollableHeight = contentHeight - scrollViewHeight
    let doesTheUserWantToGoToTheNextPage = offsetY > scrollableHeight
    let isTheNextPageAvailable = !isPaging && dataSource?.hasMorePages ?? false
    if doesTheUserWantToGoToTheNextPage && isTheNextPageAvailable {
      baseDelegate?.scrollToNextPage()
    }
  }
}

// MARK: - Private helper
private extension PostViewAdapter {
  func checkLastCell(_ cell: PostCellEdgeDividable?, indexPath: IndexPath) {
    if let numberOfItems = dataSource?.numberOfItems, indexPath.item == numberOfItems - 1 {
      cell?.hideCellDivider()
    }
  }
  
  func makePostCell(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath,
    with numberOfThumbnails: PostThumbnailCountValue
  ) -> (any UICollectionViewCell & PostCellConfigurable & PostCellEdgeDividable)? {
    return switch numberOfThumbnails {
    case .one:
      collectionView.dequeueReusableCell(
        withReuseIdentifier: PostCellWithOneThumbnail.id, for: indexPath
      ) as? PostCellWithOneThumbnail
    case .two:
      collectionView.dequeueReusableCell(
        withReuseIdentifier: PostCellWithTwoThumbnails.id, for: indexPath
      ) as? PostCellWithTwoThumbnails
    case .three:
      collectionView.dequeueReusableCell(
        withReuseIdentifier: PostCellWithThreeThumbnails.id, for: indexPath
      ) as? PostCellWithThreeThumbnails
    case .four:
      collectionView.dequeueReusableCell(
        withReuseIdentifier: PostCellWithFourThumbnails.id, for: indexPath
      ) as? PostCellWithFourThumbnails
    case .five:
      collectionView.dequeueReusableCell(
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
