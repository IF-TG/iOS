//
//  BaseNavigationRightButton.swift
//  travelPlan
//
//  Created by SeokHyun on 1/5/24.
//

import UIKit

/// 완료버튼
class BaseNavigationRightButton: UIButton {
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

// MARK: - Private Helpers
extension BaseNavigationRightButton {
  private func setup() {
    setTitle("완료", for: .normal)
    setTitleColor(.yg.gray1, for: .normal)
    titleLabel?.font = .init(pretendard: .regular_400(fontSize: 16))
  }
}
