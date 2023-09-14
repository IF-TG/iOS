//
//  BaseBottomSheetViewController.swift
//  travelPlan
//
//  Created by 양승현 on 2023/09/13.
//

import UIKit
 
class BaseBottomSheetViewController: UIViewController {
  enum Constants {
    static let bgColor = UIColor(hex: "#000000", alpha: 0.1)
    
    enum BottomSheetView {
      static let minimumHeihgt: CGFloat = 50
    }
  }
  
  // MARK: - Properties
  private var bottomSheetView = BaseBottomSheetView()
  
  private var safeAreaBottomView = UIView(frame: .zero).set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = .white
  }
  
  private lazy var bottomSheetHeight: NSLayoutConstraint = bottomSheetView
    .heightAnchor
    .constraint(equalToConstant: Constants.BottomSheetView.minimumHeihgt)
  
  // MARK: - Lifecycle
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    modalPresentationStyle = .overFullScreen
  }
  
  convenience init() {
    self.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    modalPresentationStyle = .overFullScreen
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
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
    view.backgroundColor = Constants.bgColor
    view.bringSubviewToFront(safeAreaBottomView)
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
