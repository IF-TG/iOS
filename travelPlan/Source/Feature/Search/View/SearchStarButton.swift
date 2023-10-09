//
//  SearchStarButton.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/08/17.
//

import UIKit

final class SearchStarButton: UIButton {
  enum BorderColor: String {
    case black
    case white
    
    var imagePath: String {
      switch self {
      case .black:
        return Constants.borderBlack
      case .white:
        return Constants.borderWhite
      }
    }
  }
  
  enum Constants {
    static let borderBlack = "emptyStar-border-black"
    static let borderWhite = "emptyStar-border-white"
    static let selectedImageName = "star-filled"
  }

  // MARK: - LifeCycle
  convenience init(normalType: BorderColor) {
    self.init(frame: .zero, normalType: normalType)
  }
  
  convenience init() {
    self.init(frame: .zero, normalType: .black)
  }
  
  init(frame: CGRect, normalType: BorderColor) {
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
  private func setImages(normalType: BorderColor) {
    setImage(UIImage(named: normalType.imagePath), for: .normal)
    setImage(UIImage(named: Constants.selectedImageName), for: .selected)
  }
}
