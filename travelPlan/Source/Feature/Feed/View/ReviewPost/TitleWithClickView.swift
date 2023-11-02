//
//  TitleWithClickView.swift
//  travelPlan
//
//  Created by SeokHyun on 11/3/23.
//

import UIKit
import SnapKit

class TitleWithClickView: UIView {
  enum ClickImageLayout {
    case left
    case right
  }
  
  enum Constant {
    enum ClickImageView {
      enum Spacing {
        static let trailing: CGFloat = -2
      }
      static let width: CGFloat = 20
      static let height: CGFloat = 20
    }
  }
  
  // MARK: - Properties
  private let clickImageView: UIImageView = .init().set {
    $0.image = .init(named: "chevron")
  }
  
  private let titleLabel: UILabel = .init().set {
    $0.text = "타이틀"
    $0.font = .init(pretendard: .semiBold_600(fontSize: 14))
    $0.textColor = .yg.gray5
  }
  
  override var intrinsicContentSize: CGSize {
    let width = Constant.ClickImageView.width +
    titleLabel.intrinsicContentSize.width +
    Constant.ClickImageView.Spacing.trailing
    let height = max(Constant.ClickImageView.height,
                     titleLabel.intrinsicContentSize.height)
    print("width: \(clickImageView.frame.width), height: \(clickImageView.frame.height)")
    return .init(width: width, height: height)
  }
  
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
extension TitleWithClickView: LayoutSupport {
  func addSubviews() {
    addSubview(clickImageView)
    addSubview(titleLabel)
  }
  
  func setConstraints() {
    clickImageView.snp.makeConstraints {
      typealias Const = Constant.ClickImageView
      $0.centerY.equalToSuperview()
      $0.width.equalTo(Const.width)
      $0.height.equalTo(Const.height)
      $0.leading.equalToSuperview()
      $0.trailing.equalTo(titleLabel.snp.leading).offset(Const.Spacing.trailing)
    }
    
    titleLabel.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.trailing.equalToSuperview()
    }
  }
}
