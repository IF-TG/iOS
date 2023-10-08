//
//  BaseBottomSheetViewController.swift
//  travelPlan
//
//  Created by 양승현 on 2023/09/13.
//

import UIKit
 
class BaseBottomSheetViewController: UIViewController {
  enum ContentMode {
    // bottomSheet가 꽉 찬 화면
    case full
    // bottomSheet가 내부 tableView cell 추가로 꽉 찰 수 있는 경우
    case couldBeFull
  }
  
  enum Constants {
    static let animationDuration: CGFloat = 0.43
    static let bgColor = UIColor(hex: "#000000", alpha: 0.2)
    
    enum BottomSheetView {
      static let minimumHeihgt: CGFloat = 50
    }
  }
  
  // MARK: - Properties
  private var bottomSheetView = BottomSheetView()
  
  private var safeAreaBottomView = UIView(frame: .zero).set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = .white
  }
  
  private var bottomSheetOriginY: CGFloat!
  
  private var bottomSheetOriginHeight: CGFloat!
  
  private var contentMode: ContentMode = .full

  // MARK: - Lifecycle
  init(mode: ContentMode) {
    contentMode = mode
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setBottomSheetBeforeAnimation()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    showViewWithAnimation()
    showBottomSheetWithAnimation()
    setBottomSheetOriginProperties()
    
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
    bottomSheetView.baseDelegate = self
  }
  
  override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
    hideViewWithAnimation()
    hideBottomSheetWithAnimation {
      super.dismiss(animated: flag, completion: completion)
    }
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let touch = touches.first {
      let hitCount = view.subviews.filter {
        let position = touch.location(in: view)
        guard $0.frame.contains(position) else {
          return false
        }
        return true
      }.count
      if hitCount < 1 {
        dismiss(animated: false)
      }
    }
  }
  
  // MARK: - Helper
  func setContentView(_ contentView: UIView) {
    bottomSheetView.setContentView(contentView)
    setBottomSheetOriginProperties()
  }
  
  func setCornerRadius(_ radius: CGFloat) {
    bottomSheetView.setCornerRadius(radius)
  }
  
  // MARK: - Private helper
  private func configureUI() {
    setupUI()
  }
  
  private func setBottomSheetOriginProperties() {
    bottomSheetOriginY = bottomSheetView.frame.origin.y
    bottomSheetOriginHeight = bottomSheetView.frame.height
  }
  
  private func showViewWithAnimation() {
    UIView.animate(
      withDuration: Constants.animationDuration,
      delay: 0,
      options: .curveEaseInOut
    ) {
      self.view.backgroundColor = Constants.bgColor
    }
  }
  
  private func hideViewWithAnimation() {
    UIView.animate(
      withDuration: Constants.animationDuration,
      delay: 0,
      options: .curveEaseInOut
    ) {
      self.view.backgroundColor = .none
    }
  }
  
  private func setBottomSheetBeforeAnimation() {
    bottomSheetView.transform = .init(translationX: 0, y: self.view.bounds.height)
    safeAreaBottomView.transform = .init(translationX: 0, y: self.view.bounds.height)
  }
  
  private func showBottomSheetWithAnimation() {
    UIView.animate(
      withDuration: Constants.animationDuration,
      delay: 0,
      options: .curveEaseInOut
    ) {
      self.bottomSheetView.transform = .identity
      self.safeAreaBottomView.transform = .identity
    }
  }
  
  private func hideBottomSheetWithAnimation(_ completion: @escaping () -> Void) {
    UIView.animate(
      withDuration: Constants.animationDuration,
      delay: 0,
      options: .curveEaseInOut,
      animations: {
      self.bottomSheetView.transform = .init(translationX: 0, y: self.view.bounds.height)
      self.safeAreaBottomView.transform = .init(translationX: 0, y: self.view.bounds.height)
      }
    ) { _ in
      completion()
    }
  }
  
  private func updateBottomSheetPosition(from y: CGFloat) {
    bottomSheetView.transform = .init(translationX: 0, y: y)
    safeAreaBottomView.transform = .init(translationX: 0, y: y)
  }
  
  private func animateBottomSheetWithOriginPosition(_ gesture: UIPanGestureRecognizer) {
    bottomSheetView.isUserInteractionEnabled = false
    gesture.cancelsTouchesInView = true
    UIView.animate(
      withDuration: Constants.animationDuration,
      delay: 0,
      options: .curveEaseInOut,
      animations: {
        self.bottomSheetView.transform = .identity
        self.safeAreaBottomView.transform = .identity
      }) { _ in
        self.bottomSheetView.isUserInteractionEnabled = true
      }
  }
}

// MARK: - BottomSheetViewDelegate
extension BaseBottomSheetViewController: BottomSheetViewDelegate {
  func bottomSheetView(
    _ bottomSheetView: BottomSheetView,
    withPenGesture gesture: UIPanGestureRecognizer
  ) {
    let translation = gesture.translation(in: bottomSheetView)
    let pannedHeight = translation.y
    let isDraggingDown = pannedHeight > 0
    guard isDraggingDown else { return }
    switch gesture.state {
    case .changed:
      updateBottomSheetPosition(from: pannedHeight)
    case .ended,
         .cancelled:
      guard pannedHeight >= (bottomSheetOriginHeight)/3 else {
        animateBottomSheetWithOriginPosition(gesture)
        return
      }
      dismiss(animated: false)
    default:
      break
    }
  }
}

// MARK: - LayoutSupportable
extension BaseBottomSheetViewController: LayoutSupport {
  func addSubviews() {
    _=[bottomSheetView,
       safeAreaBottomView
    ].map {
      view.addSubview($0)
    }
  }
  
  func setConstraints() {
    _=[bottomSheetViewConstraints,
      safeAreaBottomViewConstraints
    ].map {
      NSLayoutConstraint.activate($0)
    }
  }
}

// MARK: - Layout supportable private helper
private extension BaseBottomSheetViewController {
  var bottomSheetViewConstraints: [NSLayoutConstraint] {
    typealias Const = Constants.BottomSheetView
    let constraints = [
      bottomSheetView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      bottomSheetView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      bottomSheetView.bottomAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.bottomAnchor)]
    if contentMode == .full {
      return constraints + [bottomSheetView.topAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.topAnchor)]
    }
    return constraints + [bottomSheetView.topAnchor.constraint(
      greaterThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor)]
  }
  
  var safeAreaBottomViewConstraints: [NSLayoutConstraint] {
    return [
      safeAreaBottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      safeAreaBottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      safeAreaBottomView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      safeAreaBottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor)]
  }
}
