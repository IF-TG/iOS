//
//  CopyAlertView.swift
//  travelPlan
//
//  Created by SeokHyun on 6/6/24.
//

import UIKit
import SnapKit

final class CopyAlertView: UIView {
  // MARK: - Properties
  private let label = UILabel().set {
    $0.text = "복사되었습니다."
    $0.textColor = .white
    $0.font = UIFont(pretendard: .medium_500(fontSize: 16))
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
extension CopyAlertView {
  private func setupStyles() {
    backgroundColor = .yg.primary.withAlphaComponent(0.8)
    layer.cornerRadius = 6
  }
}

extension CopyAlertView: LayoutSupport {
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

// MARK: - Helpers
extension CopyAlertView {
  func performGhostAnimation() {
    UIView.animate(withDuration: 1.0, animations: {
      self.isHidden = false
      self.alpha = 1
      
      DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        UIView.animate(withDuration: 0.5, animations: {
          self.alpha = 0
        }) { _ in
          self.isHidden = true
        }
      }
    })
  }
}
