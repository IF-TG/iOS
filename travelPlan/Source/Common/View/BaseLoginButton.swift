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
  private var logoImageView: UIImageView!
  private var logoLabel: UILabel!
  
  // MARK: - LifeCycle
  convenience init(imageView: UIImageView, textLabel: UILabel) {
    self.init(frame: .zero)
  }
  
  private override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - LayoutSupport
extension BaseLoginButton: LayoutSupport {
  func addSubviews() {
    addSubview(logoImageView)
    addSubview(logoLabel)
  }
  
  func setConstraints() {
    logoImageView.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.equalToSuperview().inset(14)
    }
    
    logoLabel.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.centerX.equalToSuperview()
    }
  }
}
