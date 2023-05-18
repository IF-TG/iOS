//
//  FavoriteViewController.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/05/05.
//

import UIKit

class FavoriteViewController: UIViewController {
  // MARK: - Properties
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
  }
  
}

// MARK: - Private helpers
private extension FavoriteViewController {
  func configureUI() {
    view.backgroundColor = Constant.bgColor
    setNavigationBarTitle()
    setNavigationRightBarItem()
  }
  
  func setNavigationBarTitle() {
    let titleLabel = UILabel().set {
      $0.text = "찜 목록"
      $0.textColor = Constant.NavigationBar.Title.color
      $0.font = Constant.NavigationBar.Title.font
      $0.textAlignment = .center
    }
    navigationItem.titleView = titleLabel
  }
  
  func setNavigationRightBarItem() {
    let settingButton = UIButton().set {
      let image = UIImage(
        named: Constant.NavigationBar.Setting.iconName)
      $0.setImage(image, for: .normal)
      $0.setImage(
        image!.setColor(Constant.NavigationBar.Setting.touchedColor),
        for: .highlighted)
      $0.addTarget(
        self,
        action: #selector(didTapSettingButton),
        for: .touchUpInside)
    }
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      customView: settingButton)
  }
}

// MARK: - Action
extension FavoriteViewController {
  @objc func didTapSettingButton() {
    print("DEBUG: Tap setting button")
  }
}
