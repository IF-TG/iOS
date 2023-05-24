//
//  RecommendationSearchFooterView.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/05/17.
//

import UIKit

class RecommendationSearchFooterView: UICollectionReusableView {
  // MARK: - Properties
  static var id: String {
    return String(describing: self)
  }
  
  private let underLineView = OneUnitHeightLine(color: .yg.gray0)
  
  // MARK: - LifeCycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - LayoutSupport
extension RecommendationSearchFooterView: LayoutSupport {
  func addSubviews() {
    addSubview(underLineView)
  }
  
  func setConstraints() {
    underLineView.setConstraint(
      fromSuperView: self,
      spacing: .init(leading: 20, trailing: 20, bottom: 10, top: 10)
    )
  }
}
