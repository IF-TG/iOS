//
//  LoginView.swift
//  travelPlan
//
//  Created by SeokHyun on 10/28/23.
//

import UIKit
import SnapKit

final class LoginView: UIView {
  enum Constant {
    enum YeoGaLogo {
      static let imagePath = "yeoga-logo"
    }
    enum AirplaneLogo {
      static let imagePath = "airplane-logo"
    }
    enum FirstDescriptionLabel {
      static let fontSize: CGFloat = 16
      static let text = "설레는 여행의 내딛음"
    }
    enum LoginDescriptionLabel {
      static let fontSize: CGFloat = 20
      static let numberOfLines = 0
      static let text = "설레는 여행의 내딛음,\n여행을 가다"
    }
    enum ButtonStackView {
      static let spacing: CGFloat = 7
    }
    enum PolicyLabel {
      static let text = "로그인 시 이용약관 / 개인정보 처리방침 동의로 간주합니다."
      static let fontSize: CGFloat = 12
    }
  }
  
  // MARK: - Properties
  private let loginStartView = LoginStartView()
  private let yeoGaLogo: UIImageView = .init().set {
    $0.image = UIImage(named: Constant.YeoGaLogo.imagePath)?.withRenderingMode(.alwaysTemplate)
    $0.tintColor = .yg.littleWhite
  }
  private let airplaneLogo: UIImageView = .init().set {
    $0.image = UIImage(named: Constant.AirplaneLogo.imagePath)?.withRenderingMode(.alwaysTemplate)
    $0.contentMode = .scaleToFill
    $0.tintColor = .yg.primary
  }
  
  private let firstDescriptionLabel = UILabel().set {
    typealias Const = Constant.FirstDescriptionLabel
    $0.font = .init(pretendard: .medium, size: Const.fontSize)
    $0.textColor = .yg.littleWhite
    $0.text = Const.text
  }
  
  private lazy var loginDescriptionLabel = UILabel().set {
    typealias Const = Constant.LoginDescriptionLabel
    $0.text = Const.text
    $0.font = .init(pretendard: .medium, size: Const.fontSize)
    $0.textColor = .yg.littleWhite
    $0.numberOfLines = Const.numberOfLines
    setAttributedTextOfloginDescriptionLabel($0)
  }
  
  private lazy var kakaoButton = KakaoLoginButton().set {
    $0.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
  }
  private lazy var appleButton = AppleLoginButton().set {
    $0.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
  }
  private lazy var googleButton = GoogleLoginButton().set {
    $0.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
  }
  
  private let buttonStackView: UIStackView = .init().set {
    $0.axis = .vertical
    $0.distribution = .fillEqually
    $0.spacing = Constant.ButtonStackView.spacing
  }
  private lazy var policyLabel: UILabel = .init().set {
    typealias Const = Constant.PolicyLabel
    $0.font = .init(pretendard: .regular, size: Const.fontSize)
    $0.text = Const.text
    $0.textColor = .white
    setAttributedTextOfPolicyDescriptionLabel($0)
  }
  
  weak var delegate: LoginButtonDelegate?
  
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
  private func setupBottomComponents() {
    addSubview(buttonStackView)
    addSubview(policyLabel)
    _ = [self.kakaoButton,
         self.appleButton,
         self.googleButton]
      .map { buttonStackView.addArrangedSubview($0) }
    
    kakaoButton.snp.makeConstraints {
      $0.height.equalTo(46)
    }
    buttonStackView.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(26)
    }
    policyLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(buttonStackView.snp.bottom).offset(16)
      $0.bottom.equalTo(safeAreaLayoutGuide).inset(22)
    }
    policyLabel.alpha = 0
    self.buttonStackView.alpha = 0
  }
  
  private func setupStyles() {
    backgroundColor = .clear
  }
  
  private func setAttributedTextOfPolicyDescriptionLabel(_ label: UILabel) {
    let attributedString = NSMutableAttributedString(string: label.text!)
    let firstRange = (label.text! as NSString).range(of: "이용약관")
    let secondRange = (label.text! as NSString).range(of: "개인정보 처리방침")
    let underlineAttrs: [NSAttributedString.Key: Any] = [
      .underlineStyle: NSUnderlineStyle.single.rawValue
    ]
    attributedString.addAttributes(underlineAttrs, range: firstRange)
    attributedString.addAttributes(underlineAttrs, range: secondRange)
    
    label.attributedText = attributedString
  }
  
  private func setAttributedTextOfloginDescriptionLabel(_ label: UILabel) {
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
        
        self?.setupTopComponents()
        self?.disappearFirstDescriptionLabel()
        self?.setupBottomComponents()

        UIView.animate(withDuration: 1, animations: {
          self?.layoutIfNeeded()
        }) { _ in
          UIView.animate(withDuration: 0.5) {
            self?.buttonStackView.alpha = 1
            self?.policyLabel.alpha = 1
          }
        }
      }
    }
  }
  
  private func setupTopComponents() {
    self.addSubview(loginDescriptionLabel)
    loginDescriptionLabel.snp.makeConstraints {
      $0.leading.equalToSuperview().inset(25)
      $0.top.equalTo(airplaneLogo.snp.bottom).offset(8)
    }
    airplaneLogo.snp.remakeConstraints {
      $0.top.equalTo(self.safeAreaLayoutGuide).inset(20)
      $0.leading.equalTo(loginDescriptionLabel.snp.trailing).offset(-20)
      $0.width.equalTo(48)
      $0.height.equalTo(30)
    }
    yeoGaLogo.snp.remakeConstraints {
      $0.leading.equalToSuperview().inset(25)
      $0.top.equalTo(loginDescriptionLabel.snp.bottom).offset(20)
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
    addSubview(yeoGaLogo)
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
      $0.trailing.equalTo(yeoGaLogo).offset(8)
    }
    
    yeoGaLogo.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(airplaneLogo.snp.bottom).offset(10)
      $0.width.equalTo(125)
      $0.height.equalTo(47.5)
    }
    
    firstDescriptionLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(yeoGaLogo.snp.bottom).offset(15)
    }
  }
}

// MARK: - Actions
extension LoginView {
  @objc private func didTapLoginButton(_ button: UIButton) {
    delegate?.loginButton(button)
  }
}
