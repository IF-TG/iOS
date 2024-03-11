//
//  PostRecentSearchTagCellDelegate.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/05/20.
//

import UIKit

/// 어느 cell에서 버튼이 눌렸는지 판단하기 위해 해당 cell의 참조값을 인자로 전달합니다.
protocol PostRecentSearchTagCellDelegate: AnyObject {
  func didTapTagDeleteButton(in recentTagCell: UICollectionViewCell)
}
