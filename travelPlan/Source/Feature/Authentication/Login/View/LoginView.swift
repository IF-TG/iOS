//
//  LoginView.swift
//  travelPlan
//
//  Created by SeokHyun on 10/28/23.
//

import UIKit
import SnapKit

class LoginView: UIView {
  // MARK: - Properties
  private let loginStartView = LoginStartView()
  private let yeogaLogo: UIImageView = .init().set {
    $0.image = UIImage(named: "yeoga-logo")?.withRenderingMode(.alwaysTemplate)
    $0.tintColor = .yg.littleWhite
  }
  private let airplaneLogo: UIImageView = .init().set {
    $0.image = UIImage(named: "airplane-logo")?.withRenderingMode(.alwaysTemplate)
    $0.contentMode = .scaleToFill
    $0.tintColor = .yg.primary
  }
  
  private let firstDescriptionLabel = UILabel().set {
    $0.font = .init(pretendard: .medium, size: 16)
    $0.textColor = .yg.littleWhite
    $0.text = "설레는 여행의 내딛음"
  }
  
  private lazy var loginDescriptionLabel = UILabel().set {
    $0.text = "설레는 여행의 내딛음,\n여행을 가다"
    $0.font = .init(pretendard: .medium, size: 20)
    $0.textColor = .yg.littleWhite
    $0.numberOfLines = 0
    setAttributedText(of: $0)
  }
  
  // MARK: - LifeCycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
    setupLoginUI()
    setupStyles()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Private Helpers
extension LoginView {
  private func setupStyles() {
    backgroundColor = .clear
  }
  
  private func setAttributedText(of label: UILabel) {
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineHeightMultiple = 1.2
    
    let attributedString = NSMutableAttributedString(
      string: label.text!,
      attributes: [.paragraphStyle: paragraphStyle]
    )
    
    let firstRange = (label.text! as NSString).range(of: "설레는 여행")
    let firstAttrs: [NSAttributedString.Key: Any] = [
      .font: UIFont(pretendard: .bold, size: 24) ?? .systemFont(ofSize: 24),
      .foregroundColor: UIColor.yg.littleWhite
    ]
    attributedString.addAttributes(firstAttrs, range: firstRange)
    
    let primaryAttrs: [NSAttributedString.Key: Any] = [
      .font: UIFont(pretendard: .bold, size: 24) ?? .systemFont(ofSize: 24),
      .foregroundColor: UIColor.yg.primary
    ]
    
    if let secondRange = (label.text! as NSString).range(of: "여행을").validation {
      let newRange = NSRange(location: secondRange.location, length: 2)
      attributedString.addAttributes(primaryAttrs, range: newRange)
    }
    
    let thirdRange = (label.text! as NSString).range(of: "가다")
    attributedString.addAttributes(primaryAttrs, range: thirdRange)
    
    label.attributedText = attributedString
  }
  
  private func setupLoginUI() {
    loginStartView.completionHandler = { [weak self] in
      UIView.animate(withDuration: 1, animations: {
        self?.backgroundColor = .black.withAlphaComponent(0.24)
        self?.loginStartView.alpha = 0
      }) { _ in
        self?.loginStartView.snp.removeConstraints()
        self?.loginStartView.removeFromSuperview()
        
        guard let self else { return }
        self.setupTopComponents()
        self.disappearFirstDescriptionLabel()
        
        UIView.animate(withDuration: 1) {
          self.layoutIfNeeded()
        }
      }
    }
  }
  
  private func setupTopComponents() {
    self.addSubview(self.loginDescriptionLabel)
    self.loginDescriptionLabel.snp.makeConstraints {
      $0.leading.equalToSuperview().inset(25)
      $0.top.equalTo(self.airplaneLogo.snp.bottom).offset(8)
    }
    self.airplaneLogo.snp.remakeConstraints {
      $0.top.equalTo(self.safeAreaLayoutGuide).inset(20)
      $0.leading.equalTo(self.loginDescriptionLabel.snp.trailing).offset(-20)
      $0.width.equalTo(48)
      $0.height.equalTo(30)
    }
    self.yeogaLogo.snp.remakeConstraints {
      $0.leading.equalToSuperview().inset(25)
      $0.top.equalTo(self.loginDescriptionLabel.snp.bottom).offset(20)
      $0.width.equalTo(125)
      $0.height.equalTo(47.5)
    }
  }
  
  private func disappearFirstDescriptionLabel() {
    UIView.animate(withDuration: 0.5,
                   animations: {
      self.firstDescriptionLabel.alpha = 0
    }) { _ in
      self.firstDescriptionLabel.snp.removeConstraints()
      self.firstDescriptionLabel.removeFromSuperview()
    }
  }
}

// MARK: - LayoutSupport
extension LoginView: LayoutSupport {
  func addSubviews() {
    addSubview(loginStartView)
    addSubview(airplaneLogo)
    addSubview(yeogaLogo)
    addSubview(firstDescriptionLabel)
  }
  
  func setConstraints() {
    loginStartView.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.bottom.equalToSuperview().inset(60)
      $0.width.equalTo(70)
      $0.height.equalTo(LoginStartView.Constant.CircleView.size * 2.5 +
                        LoginStartView.Constant.CircleView.Spacing.leadingTrailingBottom)
    }
    
    airplaneLogo.snp.makeConstraints {
      $0.top.equalTo(self.safeAreaLayoutGuide).offset(50)
      $0.width.equalTo(48)
      $0.height.equalTo(30)
      $0.trailing.equalTo(yeogaLogo).offset(8)
    }
    
    yeogaLogo.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(airplaneLogo.snp.bottom).offset(10)
      $0.width.equalTo(125)
      $0.height.equalTo(47.5)
    }
    
    firstDescriptionLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(yeogaLogo.snp.bottom).offset(15)
    }
  }
}
