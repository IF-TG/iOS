//
//  PostRecentSearchTagCellDelegate.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/05/20.
//

import UIKit

protocol PostRecentSearchTagCellDelegate: AnyObject {
  func didTapTagDeleteButton(in recentTagCell: UICollectionViewCell)
}
