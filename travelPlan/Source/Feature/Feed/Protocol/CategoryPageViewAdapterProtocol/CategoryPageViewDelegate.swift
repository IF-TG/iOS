//
//  CategoryPageViewDelegate.swift
//  travelPlan
//
//  Created by 양승현 on 2023/07/02.
//

import UIKit

protocol CategoryPageViewDelegate: AnyObject {
  func collectionView(
    _ collectionView: UICollectionView,
    didSelectItemAt indexPath: IndexPath,
    scrollBarLeadingInset leadingInset: CGFloat)
  func collectionView(
    _ collectionView: UICollectionView,
    willDisplayFirstCell cell: UICollectionViewCell,
    scrollBarLeadingInset leadingInset: CGFloat)
}
