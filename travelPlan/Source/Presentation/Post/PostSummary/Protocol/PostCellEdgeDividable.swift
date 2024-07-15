//
//  PostCellEdgeDividable.swift
//  travelPlan
//
//  Created by 양승현 on 7/13/24.
//

import UIKit

protocol PostCellEdgeDividable: AnyObject {
  func hideCellDivider()
}

extension PostCellEdgeDividable where Self: PostCellLayouter, Self: UICollectionViewCell {
  func hideCellDivider() {
    self.postView.hideCellDivider()
  }
}
