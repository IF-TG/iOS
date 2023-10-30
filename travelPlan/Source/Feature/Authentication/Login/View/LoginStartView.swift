//
//  LoginStartView.swift
//  travelPlan
//
//  Created by SeokHyun on 10/15/23.
//

import UIKit
import SnapKit

final class LoginStartView: UIView {
  enum Constant {
    enum ArrowImageView1 {
      static let imagePath = "arrow-up-onboarding"
      static let width: CGFloat = 14
    }
    enum ArrowImageView2 {
      static let imagePath = "arrow-up-onboarding"
      static let width: CGFloat = 14
    }
    enum ArrowStackView {
      static let spacing: CGFloat = 4
      static let height: CGFloat = 20
      enum Spacing {
        static let top: CGFloat = 20
      }
    }
    enum CircleView {
      static let cornerRadius: CGFloat = Constant.CircleView.size / 2
      static let size: CGFloat = 62
      enum Spacing {
        static let leadingTrailingBottom: CGFloat = 4
        static let bottom: CGFloat = 4
        static let maxTop: CGFloat = 4
      }
    }
    enum TextImageView {
      static let width: CGFloat = 26
      static let height: CGFloat = 14
    }
    enum GradientLayer {
      static let firstColorAlpha: CGFloat = 0.025
      static let secondColorAlpha: CGFloat = 0.8
      static let firstLocation: NSNumber = 0
      static let secondLocation: NSNumber = 1
      static let cornerRadius: CGFloat = 35
    }
  }
  
  // MARK: - Properties
  private let arrowImageView1: UIImageView = .init().set {
    $0.image = UIImage(named: Constant.ArrowImageView1.imagePath)?
      .withRenderingMode(.alwaysTemplate)
    $0.tintColor = .white.withAlphaComponent(0.3)
  }
  
  private let arrowImageView2: UIImageView = .init().set {
    $0.image = UIImage(named: Constant.ArrowImageView2.imagePath)?
      .withRenderingMode(.alwaysTemplate)
    $0.tintColor = .white.withAlphaComponent(0.4)
  }
  
  private lazy var arrowStackView: UIStackView = .init().set {
    $0.axis = .vertical
    $0.distribution = .fillEqually
    $0.spacing = Constant.ArrowStackView.spacing
  }
  
  private lazy var circleView: UIView = .init().set {
    $0.backgroundColor = .yg.littleWhite
    $0.layer.cornerRadius = Constant.CircleView.cornerRadius
    $0.addGestureRecognizer(panGestureRecognizer)
  }
  
  private lazy var panGestureRecognizer = UIPanGestureRecognizer(
    target: self,
    action: #selector(handlePanGesture(_:))
  )
  
  private let textImageView: UIImageView = .init().set {
    $0.image = .init(named: "go-onboarding")
    $0.contentMode = .scaleAspectFit
  }
  
  private lazy var gradientLayer: CAGradientLayer = .init()
    .set {
      $0.colors = [
        UIColor.white.withAlphaComponent(Constant.GradientLayer.firstColorAlpha).cgColor,
        UIColor.white.withAlphaComponent(Constant.GradientLayer.secondColorAlpha).cgColor
      ]
      $0.locations = [
        Constant.GradientLayer.firstLocation,
        Constant.GradientLayer.secondLocation
      ]
      $0.cornerRadius = Constant.GradientLayer.cornerRadius
  }
  
  private var isLayerFrameSet = false
  private var isCircleViewYInitialized = false
  private var initialCircleViewY: CGFloat = .zero
  var completionHandler: (() -> Void)?
  
  // MARK: - LifeCycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
    setupStyles()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    setLayerFrame()
    storeCircleViewOriginalFrame()
  }
}

// MARK: - Private Helpers
extension LoginStartView {
  private func storeCircleViewOriginalFrame() {
    if !isCircleViewYInitialized {
      initialCircleViewY = self.circleView.frame.origin.y
      isCircleViewYInitialized = true
    }
  }
  
  private func setLayerFrame() {
    guard isLayerFrameSet else {
      gradientLayer.frame = self.bounds
      isLayerFrameSet = true
      return
    }
  }
  
  private func setupStyles() {
    self.backgroundColor = .clear
  }
  
  private func animateCircleView(velocity: CGPoint) {
    let currentCircleViewX = circleView.frame.origin.x
    
    if velocity.y > 0 { // 아래로 드래그 한 경우
      UIView.animate(
        withDuration: 0.3,
        delay: 0,
        options: [.curveEaseInOut]) {
          self.circleView.frame.origin = .init(x: currentCircleViewX,
                                               y: self.initialCircleViewY)
        }
    } else { // 위로 드래그 한 경우
      UIView.animate(
        withDuration: 0.3,
        delay: 0,
        options: [.curveEaseInOut],
        animations: {
          self.circleView.frame.origin = .init(x: currentCircleViewX,
                                               y: Constant.CircleView.Spacing.maxTop)
        }
      ) { _ in
        print("시작!!!!!!!!!!!")
        self.completionHandler?()
      }
    }
  }
  
  private func coordinateCircleViewOrigin(panGesture: UIPanGestureRecognizer, origin: CGPoint) {
    switch panGesture.state {
    case .ended, .cancelled, .failed:
      circleView.frame.origin = origin
    default: return
    }
  }
}

// MARK: - LayoutSupport
extension LoginStartView: LayoutSupport {
  func addSubviews() {
    self.layer.addSublayer(gradientLayer)
    self.addSubview(arrowStackView)
    _ = [
      arrowImageView1,
      arrowImageView2
    ].map { arrowStackView.addArrangedSubview($0) }
    
    self.addSubview(circleView)
    circleView.addSubview(textImageView)
  }
  
  func setConstraints() {
    circleView.snp.makeConstraints {
      typealias Const = Constant.CircleView
      $0.leading.trailing.bottom.equalToSuperview().inset(Const.Spacing.leadingTrailingBottom)
      $0.size.equalTo(Const.size)
    }
    
    textImageView.snp.makeConstraints {
      typealias Const = Constant.TextImageView
      $0.center.equalToSuperview()
      $0.width.equalTo(Const.width)
      $0.height.equalTo(Const.height)
    }
    
    arrowStackView.snp.makeConstraints {
      typealias Const = Constant.ArrowStackView
      $0.height.equalTo(Const.height)
      $0.top.equalToSuperview().inset(Const.Spacing.top)
      $0.centerX.equalToSuperview()
    }
    
    arrowImageView1.snp.makeConstraints {
      $0.width.equalTo(Constant.ArrowImageView1.width)
    }
    arrowImageView2.snp.makeConstraints {
      $0.width.equalTo(Constant.ArrowImageView2.width)
    }
  }
}

// MARK: - Actions
extension LoginStartView {
  @objc private func handlePanGesture(_ panGesture: UIPanGestureRecognizer) {
    let currentCircleViewY = circleView.frame.origin.y
    let currentCircleViewX = circleView.frame.origin.x
    
    let translation = panGesture.translation(in: circleView)
    let newY = currentCircleViewY + translation.y
    
    if panGesture.state == .ended {
      animateCircleView(velocity: panGesture.velocity(in: circleView))
      return
    }
    
    if Constant.CircleView.Spacing.maxTop >= newY { // circleView가 top 경계를 넘으면
      let origin = CGPoint(x: currentCircleViewX, y: Constant.CircleView.Spacing.maxTop)
      coordinateCircleViewOrigin(panGesture: panGesture, origin: origin)
      return
    } else if initialCircleViewY < currentCircleViewY { // circleView가 bottom 경계를 넘으면
      let origin = CGPoint(x: currentCircleViewX, y: initialCircleViewY)
      coordinateCircleViewOrigin(panGesture: panGesture, origin: origin)
      return
    }
    
    circleView.frame.origin = .init(x: currentCircleViewX, y: newY)
    panGesture.setTranslation(.zero, in: circleView)
  }
}
