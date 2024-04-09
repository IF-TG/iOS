//
//  PrimaryColorToneRoundButton.swift
//  travelPlan
//
//  Created by 양승현 on 10/3/23.
//

import UIKit
import Combine

final class PrimaryColorToneRoundButton: UIButton {
  enum Constant {
    static let cornerRadius: CGFloat = 5
    static let textColor: UIColor = .white
    static let font: UIFont = .systemFont(ofSize: 16, weight: .init(500))
  }
  
  enum State: Toggable {
    case normal
    case selected
    
    var backgroundColor: CGColor {
      switch self {
      case .normal:
        return UIColor.yg.primary.withAlphaComponent(0.3).cgColor
      case .selected:
        return UIColor.yg.primary.cgColor
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
  var currentState: State {
    didSet {
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
    self.init(frame: .zero, currentState: .normal)
  }
  
  required init?(coder: NSCoder) {
    currentState = .normal
    super.init(coder: coder)
    configureUI()
  }
}

// MARK: - Private Helpers
extension PrimaryColorToneRoundButton {
  private func configureUI() {
    translatesAutoresizingMaskIntoConstraints = false
    layer.cornerRadius = Constant.cornerRadius
    titleLabel?.font = Constant.font
    setTitleColor(Constant.textColor, for: .normal)
    setTitle("확인", for: .normal)
    addTarget(self, action: #selector(didTapPrimaryColorToneRoundButton), for: .touchUpInside)
    setAppearance()
  }
  
  private func setAppearance() {
    layer.backgroundColor = currentState.backgroundColor
  }
}

// MARK: - Actions
extension PrimaryColorToneRoundButton {
  @objc func didTapPrimaryColorToneRoundButton() {
    tapHandler?()
  }
}
