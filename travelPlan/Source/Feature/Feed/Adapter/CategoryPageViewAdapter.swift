//
//  CategoryPageViewAdapter.swift
//  travelPlan
//
//  Created by 양승현 on 2023/06/30.
//

import UIKit

// 가나다TODO: - 이것도 컬랙션 뷰 제거해서 adapter 패턴 개념인.. protocol끼리 연결하도록 다시 리빌딩 해야함
final class CategoryPageViewAdapter: NSObject {
  weak var dataSource: CategoryPageViewDataSource?
  weak var delegate: CategoryPageViewDelegate?
  weak var categoryCollectionView: UICollectionView?
  
  init(
    dataSource: CategoryPageViewDataSource? = nil,
    delegate: CategoryPageViewDelegate? = nil,
    categoryCollectionView: UICollectionView? = nil,
    categoryDetailCollectionView: CategoryDetailView? = nil
  ) {
    super.init()
    self.dataSource = dataSource
    self.delegate = delegate
    self.categoryCollectionView = categoryCollectionView
    categoryCollectionView?.dataSource = self
    categoryCollectionView?.delegate = self
    
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
      // detailViewCell은 포스트 뷰를 갖는다. 이 뷰는 collectionView다. 즉 한개의 detailViewCell은 subview로 collectionView가 있느데 그 안에서 포스트들을 보여준다.
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
        travelTheme: TravelThemeType(rawValue: themeState) ?? .all,
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
    guard
      let categoryCollectionView = categoryCollectionView,
      let dataSource = dataSource
    else { return }
    if collectionView === categoryCollectionView {
      let lb = UILabel()
      lb.text = dataSource.categoryViewCellItem(at: indexPath.row)
      lb.font = UIFont.systemFont(
        ofSize: CategoryViewCell.Constant.Title.fontSize)
      lb.sizeToFit()
      let titleWidth = lb.bounds.width
      
      let spacing = dataSource.scrollBarLeadingSpacing(titleWidth)
      
      delegate?.didSelectItemAt(indexPath, spacing: spacing)
    }
  }
}
