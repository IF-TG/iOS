//
//  InnerRoundRectReusableView.swift
//  travelPlan
//
//  Created by 양승현 on 2023/09/24.
//

import UIKit

final class InnerRoundRectReusableView: UICollectionReusableView {
  
  static let id = String(describing: InnerRoundRectReusableView.self)
  
  // MARK: - Properties
  private let roundView = UIView(frame: .zero).set {
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
extension InnerRoundRectReusableView: LayoutSupport {
  func addSubviews() {
    _=[
      roundView
    ].map {
      addSubview($0)
    }
  }
  
  func setConstraints() {
    _=[
      roundViewConstraints
    ].map {
      NSLayoutConstraint.activate($0)
    }
  }
  
  private var roundViewConstraints: [NSLayoutConstraint] {
    return [
      roundView.leadingAnchor.constraint(
        equalTo: leadingAnchor,
        constant: 10),
      roundView.trailingAnchor.constraint(
        equalTo: trailingAnchor,
        constant: -10),
      roundView.topAnchor.constraint(
        equalTo: topAnchor,
        constant: 10),
      roundView.bottomAnchor.constraint(
        equalTo: bottomAnchor,
        constant: -10)]
  }
}
