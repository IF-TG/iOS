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
  }
  private var isSetShadow = false
  
  private let shadowLayer = CALayer()
  
  override var bounds: CGRect {
    didSet {
      if !isSetShadow {
        isSetShadow.toggle()
        setRoundViewShadow()
      } else {
        updateShadowPath()
      }
    }
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
}
// MARK: - Private helper
extension InnerRoundRectReusableView {
  private func configureUI() {
    setupUI()
  }
  
  private func setRoundViewShadow() {
    updateShadowPath()
    _=shadowLayer.set {
      $0.cornerRadius = 8
      $0.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
      $0.shadowOpacity = 1
      $0.shadowRadius = 8
      $0.shadowOffset = CGSize(width: 0, height: 2)
    }
    layer.addSublayer(shadowLayer)
    bringSubviewToFront(roundView)
  }
  
  private func updateShadowPath() {
    let shadowRect = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
    let shadowPath = UIBezierPath(roundedRect: shadowRect, cornerRadius: 8)
    shadowLayer.shadowPath = shadowPath.cgPath
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
        equalTo: leadingAnchor),
      roundView.trailingAnchor.constraint(
        equalTo: trailingAnchor),
      roundView.topAnchor.constraint(
        equalTo: topAnchor),
      roundView.bottomAnchor.constraint(
        equalTo: bottomAnchor)]
  }
}
