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
    
    var imagePath: String {
      switch self {
      case .empty:
        return Constants.emptyImageName
      case .emptyWithAlpha:
        return Constants.emptyWithAlphaImageName
      }
    }
  }
  
  enum Constants {
    static let emptyImageName = "emptyStar"
    static let emptyWithAlphaImageName = "star-alpha10"
    static let selectedImageName = "star"
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
    setImage(UIImage(named: normalType.imagePath), for: .normal)
    setImage(UIImage(named: Constants.selectedImageName), for: .selected)
  }
}
