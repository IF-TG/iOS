//
//  PostRecentSearchTagCellDelegate.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/05/20.
//

import Foundation

protocol PostRecentSearchTagCellDelegate: AnyObject {
  func didTapTagDeleteButton(in recentTagCell: PostRecentSearchTagCell)
}
