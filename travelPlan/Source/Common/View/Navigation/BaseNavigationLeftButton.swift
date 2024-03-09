//
//  BaseNavigationLeftButton.swift
//  travelPlan
//
//  Created by SeokHyun on 1/5/24.
//

import UIKit

/// 취소버튼
class BaseNavigationLeftButton: UIButton {
  // MARK: - LifeCycle
  convenience init() {
    self.init(frame: .zero)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Private Helper
extension BaseNavigationLeftButton {
  private func setup() {
    setTitle("취소", for: .normal)
    setTitleColor(.yg.gray7, for: .normal)
    setTitleColor(.yg.gray7.withAlphaComponent(0.1), for: .highlighted)
    titleLabel?.font = .init(pretendard: .regular_400(fontSize: 16))
  }
}
