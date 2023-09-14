//
//  BaseBottomSheetView.swift
//  travelPlan
//
//  Created by 양승현 on 2023/09/14.
//

import UIKit

class BaseBottomSheetView: UIView {
  enum Constants {
    static let cornerRadius: CGFloat = 8
    enum TopView {
      static let height: CGFloat = 20
    }
    
    enum TopIndicatorView {
      static let height: CGFloat = 5
      enum Inset {
        static let top: CGFloat = 5
        static let leading: CGFloat = 169
        static let trailing = leading
      }
    }
  }
  
  // MARK: - Properties
  private let topView = UIView(frame: .zero).set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = .white
  }
  
  private let topIndicatorView = UIView(frame: .zero).set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = .YG.gray1
    $0.layer.cornerRadius = Constants.TopIndicatorView.height/2
  }
  
  private var contentView = UIView(frame: .zero).set {
    $0.translatesAutoresizingMaskIntoConstraints = false
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
  
  convenience init() {
    self.init(frame: .zero)
    translatesAutoresizingMaskIntoConstraints = false
  }
  
  init(radius: CGFloat) {
    super.init(frame: .zero)
    translatesAutoresizingMaskIntoConstraints = false
    layer.cornerRadius = radius
    configureUI()
  }
  
  // MARK: - Helper
  func setContentView(_ contentView: UIView) {
    self.contentView.addSubview(contentView)
    NSLayoutConstraint.activate([
      contentView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
      contentView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
      contentView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
      contentView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)])
    layoutIfNeeded()
  }
  
  func setCornerRadius(_ radius: CGFloat) {
    layer.cornerRadius = Constants.cornerRadius
  }
  
  // MARK: - Private helper
  func configureUI() {
    setupUI()
    layer.cornerRadius = Constants.cornerRadius
    clipsToBounds = true
    layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
  }
}
// MARK: - LayoutSupportable
extension BaseBottomSheetView: LayoutSupport {
  func addSubviews() {
    _=[topView,
       topIndicatorView,
       contentView
    ].map {
      addSubview($0)
    }
  }
  
  func setConstraints() {
    _=[topViewConstraints,
       topIndicatorViewConstraints,
       contentViewConstraints
    ].map {
      NSLayoutConstraint.activate($0)
    }
  }
}

// MARK: - Layout supportable private helper
private extension BaseBottomSheetView {
  var topViewConstraints: [NSLayoutConstraint] {
    typealias Const = Constants.TopView
    return [
      topView.leadingAnchor.constraint(
        equalTo: leadingAnchor),
      topView.trailingAnchor.constraint(
        equalTo: trailingAnchor),
      topView.topAnchor.constraint(
        equalTo: topAnchor)]
  }
  
  var topIndicatorViewConstraints: [NSLayoutConstraint] {
    typealias Const = Constants.TopIndicatorView
    typealias Inset = Const.Inset
    return [
      topIndicatorView.topAnchor.constraint(
        equalTo: topView.topAnchor,
        constant: Inset.top),
      topIndicatorView.leadingAnchor.constraint(
        equalTo: leadingAnchor,
        constant: Inset.leading),
      topIndicatorView.trailingAnchor.constraint(
        equalTo: trailingAnchor,
        constant: -Inset.trailing),
      topIndicatorView.heightAnchor.constraint(equalToConstant: Const.height)]
  }
  
  var contentViewConstraints: [NSLayoutConstraint] {
    return [
      contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
      contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
      contentView.topAnchor.constraint(equalTo: topView.bottomAnchor),
      contentView.bottomAnchor.constraint(equalTo: bottomAnchor)]
  }
}
