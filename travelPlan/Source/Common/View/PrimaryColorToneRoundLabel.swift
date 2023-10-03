//
//  PrimaryColorToneRoundLabel.swift
//  travelPlan
//
//  Created by 양승현 on 10/3/23.
//

import UIKit

final class PrimaryColorToneRoundLabel: UILabel {
  enum State {
    case normal
    case selected
    
    var borderColor: UIColor {
      return .yg.primary.withAlphaComponent(0.1)
    }
    
    var backgroundColor: UIColor {
      switch self {
      case .normal:
        return .white
      case .selected:
        return .yg.primary.withAlphaComponent(0.1)
      }
    }
    
    var textColor: UIColor {
      switch self {
      case .normal:
        return .yg.gray3
      case .selected:
        return .yg.primary
      }
    }
  }
  
  // MARK: - Properties
  private var isSelected = false
  
  // MARK: - Lifecycle
  init(frame: CGSize) {
    super.init(frame: .zero)
    configureUI()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    configureUI()
  }
}

// MARK: - Private Helpers
extension PrimaryColorToneRoundLabel {
  private func configureUI() {
    translatesAutoresizingMaskIntoConstraints = false
  }
}
