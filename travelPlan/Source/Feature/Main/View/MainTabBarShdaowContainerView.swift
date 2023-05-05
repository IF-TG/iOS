//
//  MainTabBarShdaowContainerView.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/05/06.
//

import UIKit

final class MainTabBarShdaowContainerView: UIView {
  
  // MARK: - Properties
  lazy var shadowView: UIView = UIView().set {
    $0.clipsToBounds = false
    $0.frame = self.frame
  }
  
  lazy var shadowViewLayer: CALayer = CALayer().set {
    $0.shadowPath = UIBezierPath(roundedRect: shadowView.bounds, cornerRadius: 0).cgPath
    $0.shadowColor = UIColor.black.withAlphaComponent(0.08).cgColor
    $0.shadowOpacity = 1
    $0.shadowRadius = 20
    $0.shadowOffset = CGSize(width: 1, height: -10)
    $0.bounds = self.bounds
    $0.position = self.center
  }
  
  lazy var shapeView: UIView = UIView().set {
    $0.frame = self.frame
    $0.clipsToBounds = true
  }
  
  lazy var shapeViewLayer: CALayer = CALayer().set {
    $0.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
    $0.bounds = shapeView.bounds
    $0.position = shapeView.center
  }
  
  // MARK: - LifeCycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = .white
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - LayoutSupport
extension MainTabBarShdaowContainerView: LayoutSupport {
  func addSubviews() {
    shadowView.layer.addSublayer(shadowViewLayer)
    self.addSubview(shadowView)
    
    shapeView.layer.addSublayer(shapeViewLayer)
    self.addSubview(shapeView)
  }
  
  func setConstraints() { }
}
