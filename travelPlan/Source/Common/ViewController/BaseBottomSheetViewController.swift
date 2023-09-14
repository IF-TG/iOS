//
//  BaseBottomSheetViewController.swift
//  travelPlan
//
//  Created by 양승현 on 2023/09/13.
//

import UIKit
 
class BaseBottomSheetViewController: UIViewController {
  enum Constants {
    static let animationDuration: CGFloat = 0.43
    static let bgColor = UIColor(hex: "#000000", alpha: 0.1)
    
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
  
  private lazy var bottomSheetHeight: NSLayoutConstraint = bottomSheetView
    .heightAnchor
    .constraint(equalToConstant: Constants.BottomSheetView.minimumHeihgt)
  
  // MARK: - Lifecycle
  init() {
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    showViewWithAnimation()
    showBottomSheetWithAnimation()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
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
  }
  
  func setCornerRadius(_ radius: CGFloat) {
    bottomSheetView.setCornerRadius(radius)
  }
  
  // MARK: - Private helper
  private func configureUI() {
    setupUI()
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
  
  private func showBottomSheetWithAnimation() {
    bottomSheetView.transform = .init(translationX: 0, y: self.view.bounds.height)
    safeAreaBottomView.transform = .init(translationX: 0, y: self.view.bounds.height)
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
    return [
      bottomSheetView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      bottomSheetView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      bottomSheetView.topAnchor.constraint(
        greaterThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor),
      bottomSheetHeight,
      bottomSheetView.bottomAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.bottomAnchor)]
  }
  
  var safeAreaBottomViewConstraints: [NSLayoutConstraint] {
    return [
      safeAreaBottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      safeAreaBottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      safeAreaBottomView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      safeAreaBottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor)]
  }
}
