//
//  PrimaryColorToneRoundLabel.swift
//  travelPlan
//
//  Created by 양승현 on 10/3/23.
//

import UIKit

final class PrimaryColorToneRoundLabel: UILabel {
  enum Constant {
    static let textSize: CGFloat = 14
    static let cornerRadius: CGFloat = 5
  }
  
  enum State: Toggable {
    case normal
    case selected
    
    var borderColor: CGColor {
      switch self {
      case .normal:
        return UIColor.yg.primary.withAlphaComponent(0.1).cgColor
      case .selected:
        return UIColor.clear.cgColor
      }
    }
    
    var backgroundColor: CGColor {
      switch self {
      case .normal:
        return UIColor.white.cgColor
      case .selected:
        return UIColor.yg.primary.withAlphaComponent(0.1).cgColor
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
    
    var font: UIFont {
      let size = Constant.textSize
      switch self {
      case .normal:
        return .systemFont(ofSize: size, weight: .init(500))
      case .selected:
        return .systemFont(ofSize: size, weight: .init(600))
      }
    }
    
    mutating func toggle() {
      switch self {
      case .normal:
        self = .selected
      case .selected:
        self = .normal
      }
    }
  }
  
  // MARK: - Properties
  private(set) var isSelected = false {
    didSet {
      currentState.toggle()
      UIView.animate(
        withDuration: 0.2,
        delay: 0,
        options: .curveEaseInOut
      ) {
        self.setAppearance()
      }
    }
  }
  
  var tapHandler: (() -> Void)?
  
  private var currentState: State = .normal
  
  // MARK: - Lifecycle
  init(frame: CGRect, currentState: State) {
    self.currentState = currentState
    super.init(frame: frame)
    configureUI()
  }
  
  convenience init(currentState: State) {
    self.init(frame: .zero, currentState: currentState)
  }
  
  convenience init() {
    self.init(currentState: .normal)
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
    layer.cornerRadius = Constant.cornerRadius
    layer.borderWidth = 1
    textAlignment = .center
    setAppearance()
    isUserInteractionEnabled = true
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapPrimaryColorToneRoundLabel))
    addGestureRecognizer(tapGesture)
    
  }
  
  private func setAppearance() {
    font = currentState.font
    textColor = currentState.textColor
    layer.borderColor = currentState.borderColor
    layer.backgroundColor = currentState.backgroundColor
  }
}

// MARK: - Actions
extension PrimaryColorToneRoundLabel {
  @objc func didTapPrimaryColorToneRoundLabel() {
    isSelected.toggle()
    tapHandler?()
  }
}
