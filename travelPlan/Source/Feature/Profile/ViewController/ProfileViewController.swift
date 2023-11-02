//
//  ProfileViewController.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/05/05.
//

import UIKit

class ProfileViewController: UIViewController {
  enum Constant {
    enum TopSheetView {
      static let height: CGFloat = 253
    }
  }
  
  // MARK: - Properties
  weak var coordinator: ProfileCoordinatorDelegate?
  
  private let topSheetView = ProfileTopSheetView()
  
  private let settingStackViews: [UIStackView] = []
  
  private let scrollView = UIScrollView()
  
  private var isAnimated = false
   
  // MARK: - Lifecycle
  init() {
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    nil
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
    topSheetView.configure(with: "tempProfile3")
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    if !isAnimated {
      isAnimated.toggle()
      showAnimate()
    }
  }
  
  deinit {
    coordinator?.finish()
  }
}

// MARK: - Private Helpers
private extension ProfileViewController {
  func configureUI() {
    view.backgroundColor = .white
    setupUI()
  }
  
  func showAnimate() {
    topSheetView.alpha = 0.7
    topSheetView.transform = .init(translationX: 0, y: -20)
    topSheetView.prepareForAnimation()
    UIView.animate(
      withDuration: 0.28,
      delay: 0,
      options: .curveEaseOut,
      animations: {
        self.topSheetView.alpha = 1
        self.topSheetView.transform = .identity
      }, completion: { _ in
        self.topSheetView.showAnimation()
      })
  }
}

// MARK: - LayoutSupport
extension ProfileViewController: LayoutSupport {
  func addSubviews() {
    _=[
      topSheetView
    ].map {
      view.addSubview($0)
    }
  }
  
  func setConstraints() {
    _=[
      topSheetViewConstraints
    ].map {
      NSLayoutConstraint.activate($0)
    }
  }
}

// MARK: - LayoutSupport Constraints
private extension ProfileViewController {
  var topSheetViewConstraints: [NSLayoutConstraint] {
    typealias Const = Constant.TopSheetView
    return [
      topSheetView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      topSheetView.topAnchor.constraint(equalTo: view.topAnchor),
      topSheetView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      topSheetView.heightAnchor.constraint(equalToConstant: Const.height)]
  }
}
