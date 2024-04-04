//
//  PhotoOrderView.swift
//  travelPlan
//
//  Created by SeokHyun on 4/2/24.
//

import UIKit
import SnapKit

final class PhotoOrderView: UIView {
  // MARK: - Properties
  private let orderLabel: UILabel = .init().set {
    $0.textColor = .yg.gray00Background
    $0.font = .init(pretendard: .medium_500(fontSize: 14))
    $0.clipsToBounds = true
  }
  private var didSetupCornerRadius = false
  
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
    
    if !didSetupCornerRadius {
      layer.cornerRadius = bounds.width / 2
      layer.masksToBounds = true
      didSetupCornerRadius = true
    }
  }
}

// MARK: - LayoutSupport
extension PhotoOrderView: LayoutSupport {
  func addSubviews() {
    addSubview(orderLabel)
  }
  
  func setConstraints() {
    orderLabel.snp.makeConstraints {
      $0.center.equalToSuperview()
    }
  }
}

// MARK: - Helpers
extension PhotoOrderView {
  // cell prepareForReuse시점에 초기화하는 메소드 정의
  func initializeUI() {
    backgroundColor = .yg.gray00Background.withAlphaComponent(0.3)
    layer.borderColor = UIColor.yg.littleWhite.cgColor
    layer.borderWidth = 1
    orderLabel.text = ""
  }
  
  // cell configure시점에 selected case인 경우, order 및 UI 수정하는 함수 정의
  func configureOrderView(orderText: String) {
    backgroundColor = .yg.primary
    layer.borderColor = UIColor.clear.cgColor
    layer.borderWidth = 0
    orderLabel.text = orderText
  }
}

// MARK: - Private Helpers
extension PhotoOrderView {
  private func setupStyles() {
    backgroundColor = .yg.gray00Background.withAlphaComponent(0.3)
    layer.borderColor = UIColor.yg.littleWhite.cgColor
    layer.borderWidth = 1
  }
}
