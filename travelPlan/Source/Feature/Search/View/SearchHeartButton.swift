//
//  SearchHeartButton.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/08/17.
//

import UIKit

class SearchHeartButton: UIButton {
  // MARK: - LifeCycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    setImages()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Helpers
extension SearchHeartButton {
  private func setImages() {
    setImage(UIImage(named: Constants.normalImageName), for: .normal)
    setImage(UIImage(named: Constants.selectedImageName), for: .selected)
  }
}
