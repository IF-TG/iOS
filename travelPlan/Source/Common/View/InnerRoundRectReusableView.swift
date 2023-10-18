//
//  InnerRoundRectReusableView.swift
//  travelPlan
//
//  Created by 양승현 on 2023/09/24.
//

import UIKit

class InnerRoundRectReusableView: UICollectionReusableView {
  enum ShadowType: Equatable {
    case feed
    case search
    case custom(ShadowInfo)
    
    var constant: ShadowInfo {
      var `defualt` = ShadowInfo(
        color: UIColor(red: 0, green: 0, blue: 0, alpha: 0.1),
        opacity: 1,
        radius: 8,
        offset: .zero)
      switch self {
      case .feed:
        `defualt`.offset = .init(width: 0, height: 2)
        return `defualt`
      case .search:
        `defualt`.offset = .init(width: 0, height: -2)
        return `defualt`
      case .custom(let info):
        return info
      }
    }
    
    static func == (lhs: ShadowType, rhs: ShadowType) -> Bool {
      return lhs.constant == rhs.constant
    }
  }
  
  static let baseID = String(describing: InnerRoundRectReusableView.self)
  
  // MARK: - Properties
  private let roundView = UIView(frame: .zero).set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.layer.cornerRadius = 8
    $0.backgroundColor = .yg.littleWhite
  }
  private var isSetShadow = false
  
  private let shadowLayer = CALayer().set { $0.cornerRadius = 8 }
  
  private let shadowState: ShadowType
  
  private var constant: ShadowInfo {
    shadowState.constant
  }
  
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
  init(shadowType: ShadowType, frame: CGRect) {
    self.shadowState = shadowType
    super.init(frame: frame)
    configureUI()
  }
  
  convenience override init(frame: CGRect) {
    self.init(shadowType: .feed, frame: frame)
  }
  
  required init?(coder: NSCoder) {
    shadowState = .feed
    super.init(coder: coder)
    configureUI()
  }
}

// MARK: - Private Helpers
extension InnerRoundRectReusableView {
  private func configureUI() {
    setupUI()
    setShadowLayerShadowAppearance()
  }
  
  func setShadowLayerShadowAppearance() {
    _=shadowLayer.set {
      $0.shadowColor = constant.color.cgColor
      $0.shadowOpacity = constant.opacity
      $0.shadowRadius = constant.radius
      $0.shadowOffset = constant.offset
    }
  }
  
  private func setRoundViewShadow() {
    updateShadowPath()
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
