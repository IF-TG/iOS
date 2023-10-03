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
  private var isSetFirstCell = false
  
  init(
    dataSource: CategoryPageViewDataSource? = nil,
    delegate: CategoryPageViewDelegate? = nil,
    travelThemeCollectionView: TravelMainThemeCollectionView? = nil
  ) {
    super.init()
    self.dataSource = dataSource
    self.delegate = delegate
    travelThemeCollectionView?.dataSource = self
    travelThemeCollectionView?.delegate = self
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
    guard
      let dataSource = dataSource,
      let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: TravelMainCategoryViewCell.id,
        for: indexPath
      ) as? TravelMainCategoryViewCell
    else {
      return UICollectionViewCell(frame: .zero)
    }
    cell.configure(with: dataSource.cellItem(at: indexPath.row))
    return cell
  }
}

// MARK: - UICollectionViewDelegate
extension CategoryPageViewAdapter: UICollectionViewDelegate {
  /// When selected category view's cell, set scrollBar postiion, cell's position in screen
  func collectionView(
    _ collectionView: UICollectionView,
    didSelectItemAt indexPath: IndexPath
  ) {
    let cellTitle = dataSource?.travelMainCategoryTitle(at: indexPath.row)
    let scrollBarLeadingInset = calculateScrollBarInset(from: cellTitle)
    collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
    delegate?.collectionView(collectionView, didSelectItemAt: indexPath, scrollBarInset: scrollBarLeadingInset)
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    willDisplay cell: UICollectionViewCell,
    forItemAt indexPath: IndexPath
  ) {
    if !isSetFirstCell, indexPath.item == 0 && indexPath.section == 0 {
      isSetFirstCell.toggle()
      let cellTitle = dataSource?.travelMainCategoryTitle(at: indexPath.row)
      let scrollBarLeadingInset = calculateScrollBarInset(from: cellTitle)
      collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
      cell.isSelected = true
      delegate?.collectionView(collectionView, willDisplayFirstCell: cell, scrollBarLeadingInset: scrollBarLeadingInset)
    }
  }
}

// MARK: - Private Helpers
private extension CategoryPageViewAdapter {
  /// Return scrollBar specific position's leading spacing
  /// - Parameter title: 특정 TravelMainCategoryViewCell의 여행 메인 테마 title
  /// - Returns: cell에서 title을 제외한 영역중 절반 leading spacing
  func calculateScrollBarInset(from title: String?) -> CGFloat {
    typealias Const = TravelMainThemeCategoryAreaView.Constant
    let titleWidth = calculateCellTitleLabelWidth(from: title)
    let cellWidth = Const.size.width
    return (cellWidth - titleWidth) / 2.0
  }
  
  func calculateCellTitleLabelWidth(from title: String?) -> CGFloat {
    return UILabel().set {
      $0.text = title
      $0.font = UIFont.systemFont(ofSize: TravelMainCategoryViewCell.Constant.Title.fontSize)
      $0.sizeToFit()
    }
    .bounds
    .width
  }
}
