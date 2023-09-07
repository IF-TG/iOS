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
    for indexPath: IndexPath,
    in collectionView: UICollectionView
  ) -> UICollectionReusableView {
    guard let dataSource = dataSource else { return .init() }
    
    switch dataSource.fetchHeaderTitle(in: indexPath.section) {
    case let .recommendation(title):
      return self.recommendationHeaderView(for: indexPath, title: title, in: collectionView)
    case let .recent(title):
      return self.recentHeaderView(for: indexPath, title: title, in: collectionView)
    }
  }
  
  private func recommendationHeaderView(
    for indexPath: IndexPath,
    title: String,
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
    for indexPath: IndexPath,
    title: String,
    in collectionView: UICollectionView
  ) -> UICollectionReusableView {
    guard let recentHeaderView = collectionView.dequeueReusableSupplementaryView(
      ofKind: UICollectionView.elementKindSectionHeader,
      withReuseIdentifier: PostRecentSearchHeaderView.id,
      for: indexPath
    ) as? PostRecentSearchHeaderView else { return .init() }
    
    recentHeaderView.prepare(title: title, delegate: delegate)
    return recentHeaderView
  }
  
  private func footerView(
    for indexPath: IndexPath,
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
    _ collectionView: UICollectionView,
    items: [String],
    at indexPath: IndexPath
  ) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: PostRecommendationSearchTagCell.id,
      for: indexPath
    ) as? PostRecommendationSearchTagCell else { return .init() }
    
    cell.configure(items[indexPath.item])
    return cell
  }
  
  private func recentSearchTagCell(
    _ collectionView: UICollectionView,
    items: [String],
    at indexPath: IndexPath
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
      return recommendationSearchTagCell(collectionView, items: items, at: indexPath)
    case let .recent(items):
      return recentSearchTagCell(collectionView, items: items, at: indexPath)
    }
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    viewForSupplementaryElementOfKind kind: String,
    at indexPath: IndexPath
  ) -> UICollectionReusableView {
    switch kind {
    case UICollectionView.elementKindSectionHeader:
      return headerView(for: indexPath, in: collectionView)
    case UICollectionView.elementKindSectionFooter:
      return footerView(for: indexPath, in: collectionView)
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
