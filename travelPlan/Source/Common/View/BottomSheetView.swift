//
//  BottomSheetView.swift
//  travelPlan
//
//  Created by 양승현 on 2023/09/14.
//

import UIKit

protocol BottomSheetViewDelegate: AnyObject {
  func bottomSheetView(_ bottomSheetView: BottomSheetView, withPenGesture gesture: UIPanGestureRecognizer)
}

class BottomSheetView: UIView {
  enum Constants {
    static let cornerRadius: CGFloat = 8
    enum TopView {
      static let height: CGFloat = 20
    }
    
    enum TopIndicatorView {
      static let height: CGFloat = 5
      static let width: CGFloat = 36
      enum Inset {
        static let top: CGFloat = 5
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
    $0.isUserInteractionEnabled = false
  }
  
  private var contentView = UIView(frame: .zero).set {
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  
  weak var baseDelegate: BottomSheetViewDelegate?
  
  // MARK: - Lifecycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureUI()
    layer.cornerRadius = Constants.cornerRadius
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    configureUI()
    layer.cornerRadius = Constants.cornerRadius
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
  private func configureUI() {
    setupUI()
    setGesture()
    clipsToBounds = true
    layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
  }
  
  private func setGesture() {
    let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
    panGesture.delaysTouchesBegan = false
    panGesture.delaysTouchesEnded = false
    topView.addGestureRecognizer(panGesture)
  }

  // MARK: - Action
  @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
    baseDelegate?.bottomSheetView(self, withPenGesture: gesture)
  }
}

// MARK: - LayoutSupportable
extension BottomSheetView: LayoutSupport {
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
private extension BottomSheetView {
  var topViewConstraints: [NSLayoutConstraint] {
    typealias Const = Constants.TopView
    return [
      topView.leadingAnchor.constraint(
        equalTo: leadingAnchor),
      topView.trailingAnchor.constraint(
        equalTo: trailingAnchor),
      topView.topAnchor.constraint(
        equalTo: topAnchor),
      topView.heightAnchor.constraint(equalToConstant: Const.height)]
  }
  
  var topIndicatorViewConstraints: [NSLayoutConstraint] {
    typealias Const = Constants.TopIndicatorView
    typealias Inset = Const.Inset
    return [
      topIndicatorView.topAnchor.constraint(
        equalTo: topView.topAnchor,
        constant: Inset.top),
      topIndicatorView.widthAnchor.constraint(equalToConstant: Const.width),
      topIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
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
