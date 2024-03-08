//
//  BaseSettingViewController.swift
//  travelPlan
//
//  Created by 양승현 on 11/29/23.
//

import UIKit

class BaseSettingViewController: UIViewController {
  // MARK: - Properties
  private let naviTitle: String
  
  // MARK: - Lifecycle
  override func loadView() {
    super.loadView()
    view.backgroundColor = .yg.gray00Background
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    baseConfigureUI()
  }
  
  init(navigationTitle: String) {
    naviTitle = navigationTitle
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Private Helpers
private extension BaseSettingViewController {
  func baseConfigureUI() {
    setDefaultNavigationItemAppearance()
    setDefaultBackBarButton()
  }
  
  func setDefaultNavigationItemAppearance() {
    let appearance = UINavigationBarAppearance()
    appearance.backgroundColor = .white
    navigationItem.standardAppearance = appearance
    navigationItem.scrollEdgeAppearance = appearance
    navigationItem.titleView = BaseLabel(fontType: .semiBold_600(fontSize: 18), lineHeight: 22).set {
      $0.text = naviTitle
      $0.textColor = .yg.gray7
    }
  }
  
  func setDefaultBackBarButton() {
    let backButton = UIButton(frame: .zero).set {
      $0.setImage(UIImage(named: "back"), for: .normal)
      $0.widthAnchor.constraint(equalToConstant: 55).isActive = true
      $0.heightAnchor.constraint(equalToConstant: 24).isActive = true
      $0.addTarget(self, action: #selector(didTapBackBarButton(_:)), for: .touchUpInside)
      let paragraphStyle = NSMutableParagraphStyle()
      paragraphStyle.alignment = .left
      let attributes = [
        .foregroundColor: UIColor.yg.gray7,
        .font: UIFont(pretendard: .medium_500(fontSize: 16)) ?? .systemFont(ofSize: 16),
        .paragraphStyle: paragraphStyle
      ] as [NSAttributedString.Key: Any]
      let attributedString = NSAttributedString(string: "MY", attributes: attributes)
      $0.setAttributedTitle(attributedString, for: .normal)
    }
    navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
  }
}

// MARK: - Action
extension BaseSettingViewController {
  @objc func didTapBackBarButton(_ sender: Any) {
    navigationController?.popViewController(animated: true)
  }
}
