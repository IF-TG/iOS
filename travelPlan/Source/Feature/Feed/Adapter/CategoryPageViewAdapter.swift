//
//  CategoryPageViewAdapter.swift
//  travelPlan
//
//  Created by 양승현 on 2023/06/30.
//

import UIKit

final class CategoryPageViewAdapter: NSObject {
  weak var dataSource: CategoryPageViewDataSource?
  weak var delegate: CategoryPageViewDelegate?
  
  init(
    dataSource: CategoryPageViewDataSource? = nil,
    delegate: CategoryPageViewDelegate? = nil,
    travelThemeCollectionView: TravelThemeCollectionView? = nil,
    categoryDetailCollectionView: CategoryDetailView? = nil
  ) {
    super.init()
    self.dataSource = dataSource
    self.delegate = delegate
    travelThemeCollectionView?.dataSource = self
    travelThemeCollectionView?.delegate = self
    categoryDetailCollectionView?.dataSource = self
    categoryDetailCollectionView?.delegate = self
  }
}

// MARK: - UICollectionViewDataSource
extension CategoryPageViewAdapter: UICollectionViewDataSource {
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return dataSource?.numberOfItems ?? 0
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    guard let dataSource = dataSource else { return .init() }
    switch collectionView {
    case is CategoryDetailView:
      guard let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: CategoryDetailViewCell.id,
        for: indexPath
      ) as? CategoryDetailViewCell else {
        return .init(frame: .zero)
      }
      
      // TODO: - PageControl 도입 예정
      let themeState = dataSource.categoryViewCellItem(at: indexPath.row)
      let trendState = dataSource.travelTrendState
      let filterInfo = FeedPostSearchFilterInfo(
        travelTheme: TravelMainThemeType(rawValue: themeState) ?? .all,
        travelTrend: trendState)
      return cell.configure(with: filterInfo)
    default:
      guard let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: CategoryViewCell.id,
        for: indexPath
      ) as? CategoryViewCell else {
        return UICollectionViewCell(frame: .zero)
      }
      return cell.configUI(with: dataSource.categoryViewCellItem(at: indexPath.row))
    }
  }
}

// MARK: - UICollectionViewDelegate
extension CategoryPageViewAdapter: UICollectionViewDelegate {
  /// When selected category view's cell, set scrollBar postiion, cell's position in screen
  func collectionView(
    _ collectionView: UICollectionView,
    didSelectItemAt indexPath: IndexPath
  ) {
    guard let dataSource = dataSource else { return }
    if collectionView is TravelThemeCollectionView {
      let titleWidth = UILabel().set {
        $0.text = dataSource.categoryViewCellItem(at: indexPath.row)
        $0.font = UIFont.systemFont(ofSize: CategoryViewCell.Constant.Title.fontSize)
        $0.sizeToFit()
      }.bounds.width
      let spacing = dataSource.scrollBarLeadingSpacing(titleWidth)
      delegate?.didSelectItemAt(indexPath, spacing: spacing)
    }
  }
}
