//
//  TitleWithClickView.swift
//  travelPlan
//
//  Created by SeokHyun on 11/3/23.
//

import UIKit
import SnapKit

class TitleWithClickView: UIView {
  enum LayoutType {
    case leftImage
    case rightImage
  }
  
  enum Constant {
    enum ClickImageView {
      static let width: CGFloat = 20
      static let height: CGFloat = 20
    }
    static let paddingOfComponents: CGFloat = -2
  }
  
  // MARK: - Properties
  private let clickImageView: UIImageView = .init().set {
    $0.image = .init(named: "chevron")
  }
  
  private let titleLabel: UILabel = .init().set {
    $0.font = .init(pretendard: .semiBold_600(fontSize: 15))
    $0.textColor = .yg.gray5
  }
  
  override var intrinsicContentSize: CGSize {
    let width = Constant.ClickImageView.width +
    titleLabel.intrinsicContentSize.width +
    Constant.paddingOfComponents
    let height = max(Constant.ClickImageView.height,
                     titleLabel.intrinsicContentSize.height)
    
    return .init(width: width, height: height)
  }
  
  private let layoutType: LayoutType
  
  // MARK: - LifeCycle
  convenience init(title: String, layoutType: LayoutType) {
    self.init(frame: .zero, title: title, layoutType: layoutType)
  }
  
  init(frame: CGRect, title: String, layoutType: LayoutType) {
    self.layoutType = layoutType
    titleLabel.text = title
    super.init(frame: frame)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - LayoutSupport
extension TitleWithClickView: LayoutSupport {
  func addSubviews() {
    addSubview(clickImageView)
    addSubview(titleLabel)
  }
  
  func setConstraints() {
    setupCommonConstraints()
    
    switch layoutType {
    case .leftImage:
      setupLeftImageTypeConstraints()
    case .rightImage:
      setupRightImageTypeConstraints()
    }
  }
}

// MARK: - Private Helpers
extension TitleWithClickView {
  private func setupCommonConstraints() {
    clickImageView.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.width.equalTo(Constant.ClickImageView.width)
      $0.height.equalTo(Constant.ClickImageView.height)
    }
    titleLabel.snp.makeConstraints {
      $0.centerY.equalToSuperview()
    }
  }
  
  private func setupLeftImageTypeConstraints() {
    clickImageView.snp.makeConstraints {
      $0.leading.equalToSuperview()
      $0.trailing.equalTo(titleLabel.snp.leading).offset(Constant.paddingOfComponents)
    }
    titleLabel.snp.makeConstraints {
      $0.trailing.equalToSuperview()
    }
  }
  
  private func setupRightImageTypeConstraints() {
    titleLabel.snp.makeConstraints {
      $0.leading.equalToSuperview()
      $0.trailing.equalTo(clickImageView.snp.leading).offset(Constant.paddingOfComponents)
    }
    clickImageView.snp.makeConstraints {
      $0.trailing.equalToSuperview()
    }
  }
}
