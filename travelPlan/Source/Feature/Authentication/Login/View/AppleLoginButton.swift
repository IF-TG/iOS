//
//  AppleLoginButton.swift
//  travelPlan
//
//  Created by SeokHyun on 10/29/23.
//

import UIKit

final class AppleLoginButton: BaseLoginButton {
  enum Constant {
    enum TextLabel {
      static let text = "Apple 로그인"
      static let fontSize: CGFloat = 15
    }
    static let imagePath = "apple-icon"
  }
  
  // MARK: - Properties
  private let textLabel: UILabel = .init().set {
    typealias Const = Constant.TextLabel
    $0.text = Const.text
    $0.font = .init(pretendard: .semiBold, size: Const.fontSize)
    $0.textColor = .white
  }
  
  // MARK: - LifeCycle
  convenience init() {
    self.init(frame: .zero)
  }
  
  init(frame: CGRect) {
    super.init(frame: frame, imagePath: Constant.imagePath, textLabel: textLabel)
    setupStyles()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Private Helpers
extension AppleLoginButton {
  private func setupStyles() {
    backgroundColor = .black
  }
}
