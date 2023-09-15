//
//  SearchStarButton.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/08/17.
//

import UIKit

class SearchStarButton: UIButton {
  enum NormalType: String {
    case empty
    case withAlpha
  }
  
  enum Constants {
    static let emptyImageName = "emptyStar"
    static let selectedImageName = "star"
    static let alphaImageName = "star-alpha10"
  }
  
  // MARK: - Properties
  private var normalType: NormalType?
  
  // MARK: - LifeCycle
  init(normalType: NormalType) {
    self.normalType = normalType
    super.init(frame: .zero)
    
    setImages()
  }
  
//  override init(frame: CGRect) {
//    super.init(frame: frame)
//    setImages()
//  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Helpers
extension SearchStarButton {
  private func setImages() {
    switch normalType {
    case .empty, .none:
      setImage(UIImage(named: Constants.emptyImageName), for: .normal)
    case .withAlpha:
      setImage(UIImage(named: Constants.alphaImageName), for: .normal)
    }
    setImage(UIImage(named: Constants.selectedImageName), for: .selected)
  }
}
