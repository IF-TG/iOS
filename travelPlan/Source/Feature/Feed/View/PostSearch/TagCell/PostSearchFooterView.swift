//
//  PostSearchFooterView.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/05/17.
//

import UIKit

final class PostSearchFooterView: UICollectionReusableView {
  enum Constants {
    enum Inset {
      static let leading: CGFloat = 0
      static let top: CGFloat = 10
      static let trailing: CGFloat = 0
      static let bottom: CGFloat = 10
    }
  }
  
  // MARK: - Properties
  static var id: String {
    return String(describing: self)
  }
  
  private let underLineView = OneUnitHeightLine(color: .yg.gray0)
  
  // MARK: - LifeCycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - LayoutSupport
extension PostSearchFooterView: LayoutSupport {
  func addSubviews() {
    addSubview(underLineView)
  }
  
  func setConstraints() {
    underLineView.setConstraint(
      fromSuperView: self,
      spacing: .init(
        leading: Constants.Inset.leading,
        top: Constants.Inset.top,
        trailing: Constants.Inset.trailing,
        bottom: Constants.Inset.bottom
      )
    )
  }
}
