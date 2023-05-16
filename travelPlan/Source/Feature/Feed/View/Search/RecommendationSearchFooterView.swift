//
//  RecommendationSearchHeaderView.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/05/17.
//

import UIKit

class RecommendationSearchHeaderView: UICollectionReusableView {
  // MARK: - Properties
  static var id: String {
    return String(describing: self)
  }
  
  // MARK: - LifeCycle
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
