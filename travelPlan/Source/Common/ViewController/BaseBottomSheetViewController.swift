//
//  BaseBottomSheetViewController.swift
//  travelPlan
//
//  Created by 양승현 on 2023/09/13.
//

import UIKit
 
class BaseBottomSheetViewController: UIViewController {
  enum Constants {
    enum BottomSheetView {
    }
  }
  
  // MARK: - Properties
  private var bottomSheetView = BaseBottomSheetView()
  
  private var safeAreaBottomView = UIView(frame: .zero).set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = .white
  }
  
  // MARK: - Lifecycle
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    configureUI()
  }
  
  convenience init() {
    self.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    configureUI()
  }
  
  // MARK: - Helper
  
  // MARK: - Private helper
  private func configureUI() {
    setupUI()
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
      bottomSheetView.bottomAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.bottomAnchor)]
  }
  
  var safeAreaBottomViewConstraints: [NSLayoutConstraint] {
    return [
      safeAreaBottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      safeAreaBottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      safeAreaBottomView.topAnchor.constraint(equalTo: bottomSheetView.bottomAnchor),
      safeAreaBottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor)]
  }
}
