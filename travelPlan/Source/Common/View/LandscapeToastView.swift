//
//  LandscapeToastView.swift
//  travelPlan
//
//  Created by SeokHyun on 6/6/24.
//

import UIKit
import SnapKit

final class LandscapeToastView: UIView {
  // MARK: - Properties
  private let label = UILabel().set {
    $0.text = "복사되었습니다."
    $0.textColor = .white
    $0.font = UIFont(pretendard: .medium_500(fontSize: 16))
  }
  
  // MARK: - LifeCycle
  convenience init(
    color: UIColor = UIColor.yg.primary.withAlphaComponent(0.8),
    text: String
  ) {
    label.text = text
    backgroundColor = color
    self.init(frame: .zero)
  }
  
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
extension LandscapeToastView {
  private func setupStyles() {
    layer.cornerRadius = 6
  }
}

extension LandscapeToastView: LayoutSupport {
  func addSubviews() {
    addSubview(label)
  }
  
  func setConstraints() {
    label.snp.makeConstraints {
      $0.leading.equalToSuperview().inset(16)
      $0.trailing.lessThanOrEqualToSuperview().offset(-16)
      $0.centerY.equalToSuperview()
    }
  }
}
