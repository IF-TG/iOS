//
//  StackViewBuilder.swift
//  travelPlan
//
//  Created by 양승현 on 6/27/24.
//

import UIKit

public class StackViewBuilder: Builder {
  typealias Axis = NSLayoutConstraint.Axis
  typealias Distribution = UIStackView.Distribution
  typealias Alignment = UIStackView.Alignment
  
  // MARK: - Properties
  private var axis: Axis = .vertical
  private var distribution: Distribution = .fill
  private var alignment: Alignment = .fill
  private var spacing: CGFloat = 0
  private var arrangedSubviews: [UIView] = []
  
  // MARK: - Helpers
  func setAxis(_ axis: Axis) -> StackViewBuilder {
    self.axis = axis
    return self
  }
  
  func setDistribution(_ distribution: UIStackView.Distribution) -> StackViewBuilder {
    self.distribution = distribution
    return self
  }
  
  func setAlignment(_ alignment: UIStackView.Alignment) -> StackViewBuilder {
    self.alignment = alignment
    return self
  }
  
  func setSpacing(_ spacing: CGFloat) -> StackViewBuilder {
    self.spacing = spacing
    return self
  }
  
  func addArrangedSubview(_ view: UIView) -> StackViewBuilder {
    self.arrangedSubviews.append(view)
    return self
  }
  
  func addArrangedSubview(_ subviews: [UIView]) {
    arrangedSubviews.append(contentsOf: subviews)
  }
  
  func build() -> UIStackView {
    return UIStackView(arrangedSubviews: arrangedSubviews)
      .set {
        $0.axis = axis
        $0.distribution = distribution
        $0.alignment = alignment
        $0.spacing = spacing
      }
  }
}

extension UIStackView {
  typealias Builder = StackViewBuilder
}
