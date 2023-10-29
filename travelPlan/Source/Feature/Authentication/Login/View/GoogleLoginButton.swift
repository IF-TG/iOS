//
//  GoogleLoginButton.swift
//  travelPlan
//
//  Created by SeokHyun on 10/29/23.
//

import UIKit

class GoogleLoginButton: BaseLoginButton {
  // MARK: - Properties
  private let textLabel: UILabel = .init().set {
    $0.text = "Google 로그인"
    $0.font = .init(pretendard: .semiBold, size: 15)
    $0.textColor = .black.withAlphaComponent(0.85)
  }
  
  // MARK: - LifeCycle
  convenience init() {
    self.init(frame: .zero)
  }
  
  init(frame: CGRect) {
    super.init(frame: frame, imagePath: "google-icon", textLabel: textLabel)
    setupStyles()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Private Helpers
extension GoogleLoginButton {
  func setupStyles() {
    
  }
}
