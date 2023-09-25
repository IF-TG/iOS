//
//  RoundReusableView.swift
//  travelPlan
//
//  Created by 양승현 on 2023/09/24.
//

import UIKit

final class RoundReusableView: UICollectionReusableView {
  
  static let id = String(describing: RoundReusableView.self)
  
  // MARK: - Properties
  private let backgroundView = UIView(frame: .zero).set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.layer.cornerRadius = 8
    $0.backgroundColor = .yg.littleWhite
    $0.clipsToBounds = true
  }
  
  // MARK: - Lifecycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureUI()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    configureUI()
  }
  
  // MARK: - Private helper
  func configureUI() {
    setupUI()
  }
}

// MARK: - LayoutSupport
extension RoundReusableView: LayoutSupport {
  func addSubviews() {
    _=[
      backgroundView
    ].map {
      addSubview($0)
    }
  }
  
  func setConstraints() {
    _=[
      backgroundViewConstraints
    ].map {
      NSLayoutConstraint.activate($0)
    }
  }
  
  private var backgroundViewConstraints: [NSLayoutConstraint] {
    return [
      backgroundView.leadingAnchor.constraint(
        equalTo: leadingAnchor,
        constant: 10),
      backgroundView.trailingAnchor.constraint(
        equalTo: trailingAnchor,
        constant: -10),
      backgroundView.topAnchor.constraint(
        equalTo: topAnchor,
        constant: 10),
      backgroundView.bottomAnchor.constraint(
        equalTo: bottomAnchor,
        constant: -10)]
  }
}
