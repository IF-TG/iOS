//
//  BaseLoginButton.swift
//  travelPlan
//
//  Created by SeokHyun on 10/28/23.
//

import UIKit
import SnapKit

class BaseLoginButton: UIButton {
  // MARK: - Properties
  private var logoView: UIImageView!
  private var textLabel: UILabel!
  
  // MARK: - LifeCycle
  init(frame: CGRect, imagePath: String, textLabel: UILabel) {
    self.logoView = .init(image: .init(named: imagePath))
    self.textLabel = textLabel

    super.init(frame: frame)
    setupUI()
    setupStyles()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - LayoutSupport
extension BaseLoginButton: LayoutSupport {
  func addSubviews() {
    addSubview(logoView)
    addSubview(textLabel)
  }
  
  func setConstraints() {
    logoView.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.equalToSuperview().inset(14)
    }
    
    textLabel.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.centerX.equalToSuperview()
    }
  }
}

// MARK: - Private Helpers
extension BaseLoginButton {
  private func setupStyles() {
    layer.cornerRadius = 6
  }
}
