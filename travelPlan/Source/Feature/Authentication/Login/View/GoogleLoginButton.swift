//
//  GoogleLoginButton.swift
//  travelPlan
//
//  Created by SeokHyun on 10/29/23.
//

import UIKit

class GoogleLoginButton: BaseLoginButton {
  enum Constant {
    enum TextLabel {
      static let text = "Google 로그인"
      static let fontSize: CGFloat = 15
      static let alphaOfTextColor: CGFloat = 0.85
    }
    static let imagePath = "google-icon"
    static let borderWidth: CGFloat = 1
  }
  
  // MARK: - Properties
  private let textLabel: UILabel = .init().set {
    typealias Const = Constant.TextLabel
    $0.text = Const.text
    $0.font = .init(pretendard: .semiBold, size: Const.fontSize)
    $0.textColor = .black.withAlphaComponent(Const.alphaOfTextColor)
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
extension GoogleLoginButton {
  private func setupStyles() {
    backgroundColor = .white
    layer.borderColor = UIColor.yg.gray0.cgColor
    layer.borderWidth = Constant.borderWidth
  }
}
