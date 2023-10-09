//
//  PostSearchCollectionViewManager.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/09/07.
//

import UIKit

final class PostSearchCollectionViewManager: NSObject {
  // MARK: - Properties
  weak var dataSource: PostSearchCollectionViewDataSource?
  weak var delegate: (PostSearchCollectionViewDelegate &
                      PostRecentSearchTagCellDelegate &
                      PostSearchHeaderViewDelegate)?
  
  // MARK: - LifeCycle
  init(dataSource: PostSearchCollectionViewDataSource? = nil,
       delegate: (PostSearchCollectionViewDelegate &
                  PostRecentSearchTagCellDelegate &
                  PostSearchHeaderViewDelegate)? = nil) {
    self.dataSource = dataSource
    self.delegate = delegate
  }
  
  deinit {
    print("deinit: \(Self.self)")
  }
}

// MARK: - Helpers
extension PostSearchCollectionViewManager {
  private func headerView(
    at indexPath: IndexPath,
    in collectionView: UICollectionView
  ) -> UICollectionReusableView {
    guard let dataSource = dataSource else { return .init() }
    
    switch dataSource.fetchHeaderTitle(in: indexPath.section) {
    case let .recommendation(title):
      return self.recommendationHeaderView(title: title, at: indexPath, in: collectionView)
    case let .recent(title):
      return self.recentHeaderView(title: title, at: indexPath, in: collectionView)
    }
  }
  
  private func recommendationHeaderView(
    title: String,
    at indexPath: IndexPath,
    in collectionView: UICollectionView
  ) -> UICollectionReusableView {
    guard let recommendationHeaderView = collectionView.dequeueReusableSupplementaryView(
      ofKind: UICollectionView.elementKindSectionHeader,
      withReuseIdentifier: PostRecommendationSearchHeaderView.id,
      for: indexPath
    ) as? PostRecommendationSearchHeaderView else { return .init() }
    
    recommendationHeaderView.prepare(title: title)
    return recommendationHeaderView
  }
  
  private func recentHeaderView(
    title: String,
    at indexPath: IndexPath,
    in collectionView: UICollectionView
  ) -> UICollectionReusableView {
    guard let recentHeaderView = collectionView.dequeueReusableSupplementaryView(
      ofKind: UICollectionView.elementKindSectionHeader,
      withReuseIdentifier: PostRecentSearchHeaderView.id,
      for: indexPath
    ) as? PostRecentSearchHeaderView else { return .init() }
    recentHeaderView.delegate = self.delegate
    recentHeaderView.prepare(title: title)
    return recentHeaderView
  }
  
  private func footerView(
    at indexPath: IndexPath,
    in collectionView: UICollectionView
  ) -> UICollectionReusableView {
    switch indexPath.section {
    case PostSearchSection.recommendation.rawValue:
      guard let lineFooterView = collectionView.dequeueReusableSupplementaryView(
        ofKind: UICollectionView.elementKindSectionFooter,
        withReuseIdentifier: PostSearchFooterView.id,
        for: indexPath
      ) as? PostSearchFooterView else { return .init() }
      
      return lineFooterView
    default:
      return UICollectionReusableView()
    }
  }
  
  private func recommendationSearchTagCell(
    items: [String],
    at indexPath: IndexPath,
    in collectionView: UICollectionView
  ) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: PostRecommendationSearchTagCell.id,
      for: indexPath
    ) as? PostRecommendationSearchTagCell else { return .init() }
    
    cell.configure(items[indexPath.item])
    return cell
  }
  
  private func recentSearchTagCell(
    items: [String],
    at indexPath: IndexPath,
    in collectionView: UICollectionView
  ) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: PostRecentSearchTagCell.id,
      for: indexPath
    ) as? PostRecentSearchTagCell else { return .init() }
    
    cell.configure(items[indexPath.item], delegate: delegate)
    return cell
  }
}

// MARK: - UICollectionViewDataSource
extension PostSearchCollectionViewManager: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return dataSource?.numberOfSections() ?? .zero
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    dataSource?.numberOfItems(in: section) ?? .zero
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    guard let dataSource = dataSource else { return .init() }
    
    switch dataSource.cellForItems(at: indexPath.section) {
    case let .recommendation(items):
      return recommendationSearchTagCell(items: items, at: indexPath, in: collectionView)
    case let .recent(items):
      return recentSearchTagCell(items: items, at: indexPath, in: collectionView)
    }
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    viewForSupplementaryElementOfKind kind: String,
    at indexPath: IndexPath
  ) -> UICollectionReusableView {
    switch kind {
    case UICollectionView.elementKindSectionHeader:
      return headerView(at: indexPath, in: collectionView)
    case UICollectionView.elementKindSectionFooter:
      return footerView(at: indexPath, in: collectionView)
    default:
      return UICollectionReusableView()
    }
  }
}

// MARK: - UICollectionViewDelegate
extension PostSearchCollectionViewManager: UICollectionViewDelegate {
  func collectionView(
    _ collectionView: UICollectionView,
    didSelectItemAt indexPath: IndexPath
  ) {
    delegate?.didSelectTag(at: indexPath)
  }
}
