//
//  LoginStartView.swift
//  travelPlan
//
//  Created by SeokHyun on 10/15/23.
//

import UIKit
import SnapKit

class LoginStartView: UIView {
  // MARK: - Properties
  
  
  private let circleView: UIView = .init().set {
    $0.backgroundColor = .yg.littleWhite
    $0.layer.cornerRadius = 62 / 2
  }
  
  private let textImageView: UIImageView = .init().set {
    $0.image = .init(named: "go-onboarding")
    $0.contentMode = .scaleAspectFit
  }
  
  private lazy var gradientLayer: CAGradientLayer = .init()
    .set {
      $0.colors = [
        UIColor.white.withAlphaComponent(0.05).cgColor,
        UIColor.white.withAlphaComponent(0.8).cgColor
      ]
      $0.locations = [0, 1]
      $0.cornerRadius = 35
  }
  
  private var isLayerFrameSet = false
  
  // MARK: - LifeCycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
    setupStyles()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    setLayerFrame()
  }
}

// MARK: - Private Helpers
extension LoginStartView {
  private func setLayerFrame() {
    guard isLayerFrameSet else {
      gradientLayer.frame = self.bounds
      isLayerFrameSet = true
      return
    }
  }
  
  private func setupStyles() {
    self.backgroundColor = .clear
  }
}

// MARK: - LayoutSupport
extension LoginStartView: LayoutSupport {
  func addSubviews() {
    self.layer.addSublayer(gradientLayer)
    addSubview(circleView)
    circleView.addSubview(textImageView)
  }
  
  func setConstraints() {
    circleView.snp.makeConstraints {
      $0.leading.trailing.bottom.equalToSuperview().inset(4)
      $0.size.equalTo(62)
    }
    
    textImageView.snp.makeConstraints {
      $0.center.equalToSuperview()
      $0.width.equalTo(26)
      $0.height.equalTo(14)
    }
  }
}
