//
//  BaseNavigationTitleView.swift
//  travelPlan
//
//  Created by SeokHyun on 10/12/23.
//

import UIKit
import SnapKit

class BaseNavigationTitleView: UIView {
  enum Constant {
    enum DefaultLabel {
      static let fontSize: CGFloat = 18
    }
  }
  
  enum `Type` {
    case `default`(title: String?)
    case custom(customView: UIView)
    
    fileprivate var titleView: UIView {
      switch self {
      case let .default(title):
        return UILabel().set {
          $0.text = title
          $0.font = .init(pretendard: .semiBold_600, size: Constant.DefaultLabel.fontSize)
          $0.textColor = .yg.gray7
        }
      case let .custom(customView):
        return customView
      }
    }
  }
  
  // MARK: - Properties
  private let contentView: UIView
  
  // MARK: - LifeCycle
  convenience init(type: `Type`) {
    self.init(frame: .zero, type: type)
  }
  
  private init(frame: CGRect, type: `Type`) {
    self.contentView = type.titleView
    super.init(frame: frame)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - LayoutSupport
extension BaseNavigationTitleView: LayoutSupport {
  func addSubviews() {
    addSubview(contentView)
  }
  
  func setConstraints() {
    contentView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
}
