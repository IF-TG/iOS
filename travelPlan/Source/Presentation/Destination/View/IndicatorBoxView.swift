//
//  IndicatorBoxView.swift
//  travelPlan
//
//  Created by SeokHyun on 8/17/24.
//

import UIKit
import SnapKit

final class IndicatorBoxView: UIView {
  // MARK: - Constants
  enum Constants {
    static var commonColor: UIColor { .yg.gray7 }
    static var font: UIFont? { .init(pretendard: .medium_500(fontSize: 10)) }
  }
  
  // MARK: - Properties
  private let currentPageLabel = UILabel().set {
    $0.textColor = Constants.commonColor
    $0.text = "0"
    $0.font = Constants.font
  }
  
  private let totalPageLabel = UILabel().set {
    $0.textColor = Constants.commonColor
    $0.text = "0"
    $0.font = Constants.font
  }
  
  private let slashLabel = UILabel().set {
    $0.textColor = Constants.commonColor
    $0.text = "/"
    $0.font = Constants.font
  }
  
  // MARK: - LifeCycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
    setupStyles()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Private Helpers
extension IndicatorBoxView {
  private func setupStyles() {
    backgroundColor = .white.withAlphaComponent(0.5)
    layer.borderWidth = 1.5
    layer.borderColor = Constants.commonColor.cgColor
    layer.cornerRadius = 10
  }
}

// MARK: - Helpers
extension IndicatorBoxView {
  func configure(currentPage: Int, totalPage: Int) {
    currentPageLabel.text = "\(currentPage)"
    totalPageLabel.text = "\(totalPage)"
  }
  
  func update(currentPage: Int) {
    currentPageLabel.text = "\(currentPage)"
  }
}

// MARK: - LayoutSupport
extension IndicatorBoxView: LayoutSupport {
  func addSubviews() {
    addSubview(totalPageLabel)
    addSubview(slashLabel)
    addSubview(currentPageLabel)
  }
  
  func setConstraints() {
    currentPageLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview().multipliedBy(0.5)
      $0.centerY.equalToSuperview()
    }
    
    slashLabel.snp.makeConstraints {
      $0.center.equalToSuperview()
    }
    
    totalPageLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview().multipliedBy(1.5)
      $0.centerY.equalToSuperview()
    }
  }
}
