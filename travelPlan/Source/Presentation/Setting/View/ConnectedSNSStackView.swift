//
//  ConnectedSNSStackView.swift
//  travelPlan
//
//  Created by 양승현 on 11/28/23.
//

import UIKit

final class ConnectedSNSStackView: UIStackView {
  private var kakaoIcon: UIImageView!
  
  private var appleIcon: UIImageView!
  
  private var googleIcon: UIImageView!
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    axis = .horizontal
    spacing = 65
    distribution = .equalSpacing
    
    kakaoIcon = makeImageView(with: "kakao")
    appleIcon = makeImageView(with: "apple")
    googleIcon = makeImageView(with: "google")
    [kakaoIcon, appleIcon, googleIcon].forEach { addArrangedSubview($0) }
  }
  
  convenience init() {
    self.init(frame: .zero)
    translatesAutoresizingMaskIntoConstraints = false
  }
  
  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: Public Helpers
extension ConnectedSNSStackView {
  func setAppleIconConnectedState() {
    appleIcon.alpha = 1
  }
  
  func setKakaoIconConnectedState() {
    kakaoIcon.alpha = 1
  }
  
  func setGoogleIconConnectedState() {
    googleIcon.alpha = 1
  }
  
}

// MARK: - Private Helpers
private extension ConnectedSNSStackView {
  func makeImageView(with name: String) -> UIImageView {
    return UIImageView(image: UIImage(named: name + "-logo-small")).set {
      $0.contentMode = .scaleAspectFill
      $0.alpha = 0.3
      $0.widthAnchor.constraint(equalToConstant: 34).isActive = true
      $0.heightAnchor.constraint(equalToConstant: 34).isActive = true
    }
  }
}
