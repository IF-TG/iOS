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
    enum TopView {
      static let height: CGFloat = 30
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
  
  private var contentView: UIView
  
  private var bottomSheetTopAreaHeight: CGFloat
  
  weak var baseDelegate: BottomSheetViewDelegate?
  
  // MARK: - Lifecycle
  /// upperEdgeRadius는 바텀시트 상단의 radius입니다.
  init(frame: CGRect, contentView: UIView, bottomSheetInfo: BottomSheetInfo) {
    self.contentView = contentView
    bottomSheetTopAreaHeight = bottomSheetInfo.topAreaHeight
    super.init(frame: frame)
    
    configureUI()
    layer.cornerRadius = bottomSheetInfo.upperEdgeRadius
  }
  
  required init?(coder: NSCoder) { nil }
  
  convenience init(contentView: UIView, bottomSheetInfo: BottomSheetInfo = .init(topAreaHeight: 30, upperEdgeRadius: 8)) {
    self.init(frame: .zero, contentView: contentView, bottomSheetInfo: bottomSheetInfo)
    translatesAutoresizingMaskIntoConstraints = false
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
      topView.heightAnchor.constraint(equalToConstant: bottomSheetTopAreaHeight)]
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

// MARK: - Nested
extension BottomSheetView {
  struct BottomSheetInfo {
    /// 바텀시트 뷰 위쪽 터치 영역 뷰 ( 안에 터치 바 있습니다 )
    let topAreaHeight: CGFloat
    let upperEdgeRadius: CGFloat
    
    /// 기본 30
    init(topAreaHeight: CGFloat = 30, upperEdgeRadius: CGFloat) {
      self.topAreaHeight = topAreaHeight
      self.upperEdgeRadius = upperEdgeRadius
    }
  }
}
