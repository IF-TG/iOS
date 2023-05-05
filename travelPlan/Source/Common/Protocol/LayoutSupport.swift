//
//  LayoutSupport.swift
//  travelPlan
//
//  Created by 양승현 on 2023/04/29.
//

/// UIView's layout support
protocol LayoutSupport {
  
  /// Add subviews in root view
  func addSubviews()
  
  /// Set subviews constraints in root view
  func setConstraints()
}

extension LayoutSupport {
  func setupUI() {
    addSubviews()
    setConstraints()
  }
}
