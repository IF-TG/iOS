//
//  PhotoOrderView.swift
//  travelPlan
//
//  Created by SeokHyun on 4/2/24.
//

import UIKit
import SnapKit

final class PhotoOrderView: UIView {
  // MARK: - Nested
  enum Const {
    static let orderViewSize: CGFloat = 20
  }
  
  // MARK: - Properties
  private let orderView: UIView = .init().set {
    $0.backgroundColor = .yg.gray00Background.withAlphaComponent(0.3)
    $0.layer.borderColor = UIColor.yg.littleWhite.cgColor
    $0.layer.borderWidth = 1
    $0.layer.cornerRadius = Const.orderViewSize / 2
  }
  
  private let orderLabel: UILabel = .init().set {
    $0.textColor = .yg.gray00Background
    $0.font = .init(pretendard: .medium_500(fontSize: 14))
    $0.clipsToBounds = true
  }
  
  // MARK: - LifeCycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
    backgroundColor = .clear
    isUserInteractionEnabled = false
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - LayoutSupport
extension PhotoOrderView: LayoutSupport {
  func addSubviews() {
    addSubview(orderView)
    orderView.addSubview(orderLabel)
  }
  
  func setConstraints() {
    orderView.snp.makeConstraints {
      $0.top.trailing.equalToSuperview().inset(7)
      $0.size.equalTo(Const.orderViewSize)
    }
    
    orderLabel.snp.makeConstraints {
      $0.center.equalToSuperview()
    }
  }
}

// MARK: - Helpers
extension PhotoOrderView {
  // cell prepareForReuse시점에 초기화하는 메소드 정의
  func initializeUI() {
    backgroundColor = .clear
    orderView.backgroundColor = .yg.gray00Background.withAlphaComponent(0.3)
    orderView.layer.borderColor = UIColor.yg.littleWhite.cgColor
    orderView.layer.borderWidth = 1
    orderLabel.text = ""
  }
  
  // cell configure시점에 selected case인 경우, order 및 UI 수정하는 함수 정의
  func configureOrderView(orderText: String) {
    backgroundColor = .white.withAlphaComponent(0.5)
    orderView.backgroundColor = .yg.primary
    orderView.layer.borderColor = UIColor.clear.cgColor
    orderView.layer.borderWidth = 0
    orderLabel.text = orderText
  }
}
