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
    travelThemeCollectionView: TravelThemeCollectionView? = nil
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
        withReuseIdentifier: CategoryViewCell.id,
        for: indexPath
      ) as? CategoryViewCell
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
    guard let dataSource = dataSource else { return }
    if collectionView is TravelThemeCollectionView {
      let titleWidth = UILabel().set {
        $0.text = dataSource.travelMainCategoryTitle(at: indexPath.row)
        $0.font = UIFont.systemFont(ofSize: CategoryViewCell.Constant.Title.fontSize)
        $0.sizeToFit()
      }.bounds.width
      let spacing = dataSource.scrollBarLeadingSpacing(titleWidth)
      delegate?.didSelectItemAt(indexPath, spacing: spacing)
    }
  }
}
