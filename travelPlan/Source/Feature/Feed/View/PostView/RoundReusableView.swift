//
//  RoundReusableView.swift
//  travelPlan
//
//  Created by 양승현 on 2023/09/24.
//

import UIKit

final class RoundReusableView: UICollectionReusableView {
  static let id = String(describing: RoundReusableView.self)
  
  // MARK: - Lifecycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureUI()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    configureUI()
  }
  
  // MARK: - Private helper
  func configureUI() {
    layer.cornerRadius = 8
    backgroundColor = .yg.littleWhite
    clipsToBounds = true
  }
}
