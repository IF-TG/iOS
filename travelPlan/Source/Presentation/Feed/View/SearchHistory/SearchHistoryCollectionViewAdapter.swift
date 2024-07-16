//
//  SearchHistoryCollectionViewAdapter.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/09/07.
//

import UIKit

final class SearchHistoryCollectionViewAdapter: NSObject {
  // MARK: - Properties
  weak var dataSource: SearchHistoryCollectionViewDataSource?
  weak var delegate: (SearchHistoryCollectionViewDelegate &
                      SearchHistoryRecentTagCellDelegate &
                      SearchHistoryHeaderViewDelegate)?
  
  // MARK: - LifeCycle
  init(dataSource: SearchHistoryCollectionViewDataSource? = nil,
       delegate: (SearchHistoryCollectionViewDelegate &
                  SearchHistoryRecentTagCellDelegate &
                  SearchHistoryHeaderViewDelegate)? = nil) {
    self.dataSource = dataSource
    self.delegate = delegate
  }
  
  deinit {
    print("deinit: \(SearchHistoryCollectionViewAdapter.self)")
  }
}

// MARK: - Helpers
extension SearchHistoryCollectionViewAdapter {
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
    case SearchHistorySection.recommendation.rawValue:
      guard let lineFooterView = collectionView.dequeueReusableSupplementaryView(
        ofKind: UICollectionView.elementKindSectionFooter,
        withReuseIdentifier: SearchHistoryFooterView.id,
        for: indexPath
      ) as? SearchHistoryFooterView else { return .init() }
      
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
      withReuseIdentifier: SearchHistoryRecommendationTagCell.id,
      for: indexPath
    ) as? SearchHistoryRecommendationTagCell else { return .init() }
    
    cell.configure(items[indexPath.item])
    return cell
  }
  
  private func recentSearchTagCell(
    items: [String],
    at indexPath: IndexPath,
    in collectionView: UICollectionView
  ) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: SearchHistoryRecentTagCell.id,
      for: indexPath
    ) as? SearchHistoryRecentTagCell else { return .init() }
    
    cell.configure(items[indexPath.item], delegate: delegate)
    return cell
  }
}

// MARK: - UICollectionViewDataSource
extension SearchHistoryCollectionViewAdapter: UICollectionViewDataSource {
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
extension SearchHistoryCollectionViewAdapter: UICollectionViewDelegate {
  func collectionView(
    _ collectionView: UICollectionView,
    didSelectItemAt indexPath: IndexPath
  ) {
    delegate?.didSelectTag(at: indexPath)
  }
}
