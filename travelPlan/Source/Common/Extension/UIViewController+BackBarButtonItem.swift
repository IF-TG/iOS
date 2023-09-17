//
//  UIViewController+BackBarButtonItem.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/09/18.
//

import UIKit

extension UIViewController {
  /// 내비게이션의 뒤로가기 버튼을 설정합니다. 원하는 ViewController의 viewDidLoad시점에서 해당 메소드를 호출해서 사용합니다.
  ///
  /// 버튼의 크기는 image size와 동일합니다. systemName은 적용되지 않습니다.
  ///
  /// default size
  /// width: 28, height: 28
  func setupBackBarButtonItem(
    imageName: String = "back",
    tintColor: UIColor = .black,
    marginLeft: CGFloat = 10
  ) {
    self.navigationController?.isNavigationBarHidden = false
    
    let backButton = createBackButton(imageName: imageName, tintColor: tintColor, marginLeft: marginLeft)
    configureBackBarButtonItem(customView: backButton)
  }
  
  // MARK: - Actions
  /// 해당 내비게이션으로부터 pop 기능을 수행합니다.
  @objc private func didTapBackBarButtonItem() {
    self.navigationController?.popViewController(animated: true)
  }
  
  // MARK: - Privates
  private func createBackButton(
    imageName: String,
    tintColor: UIColor,
    marginLeft: CGFloat
  ) -> UIButton {
    let backButton = UIButton()
    backButton.setImage(
      UIImage(named: imageName)?.withTintColor(tintColor, renderingMode: .alwaysOriginal),
      for: .normal
    )
    backButton.addTarget(
      self,
      action: #selector(didTapBackBarButtonItem),
      for: .touchUpInside
    )
    backButton.contentEdgeInsets = .init(
      top: .zero,
      left: marginLeft,
      bottom: .zero,
      right: .zero
    )
    
    return backButton
  }
  
  private func configureBackBarButtonItem(customView: UIView) {
    let barButtonItem = UIBarButtonItem(customView: customView)
    self.navigationItem.leftBarButtonItem = barButtonItem
  }
}
