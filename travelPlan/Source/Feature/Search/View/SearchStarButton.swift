//
//  SearchStarButton.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/08/17.
//

import UIKit

final class SearchStarButton: UIButton {
  enum NormalType: String {
    case empty
    case emptyWithAlpha
  }
  
  enum Constants {
    static let emptyImageName = "emptyStar"
    static let selectedImageName = "star"
    static let alphaImageName = "star-alpha10"
  }

  // MARK: - LifeCycle
  convenience init(normalType: NormalType) {
    self.init(frame: .zero, normalType: normalType)
  }
  
  convenience init() {
    self.init(frame: .zero, normalType: .empty)
  }
  
  init(frame: CGRect, normalType: NormalType) {
    super.init(frame: frame)
    self.translatesAutoresizingMaskIntoConstraints = false
    setImages(normalType: normalType)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Helpers
extension SearchStarButton {
  private func setImages(normalType: NormalType) {
    switch normalType {
    case .empty:
      setImage(UIImage(named: Constants.emptyImageName), for: .normal)
    case .emptyWithAlpha:
      setImage(UIImage(named: Constants.alphaImageName), for: .normal)
    }
    setImage(UIImage(named: Constants.selectedImageName), for: .selected)
  }
}
