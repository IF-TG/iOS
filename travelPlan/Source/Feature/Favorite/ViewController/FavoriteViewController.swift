//
//  FavoriteViewController.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/05/05.
//

import UIKit

class FavoriteViewController: UIViewController {
  // MARK: - Properties
  private let line = OneUnitHeightLine(color: .yg.gray0)
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
    setNavigationBarEdgeGrayLine()
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
  
  func setNavigationBarEdgeGrayLine() {
    guard let naviBar = navigationController?.navigationBar else {
      return
    }
    line.setConstraint(fromSuperView: naviBar, spacing: .init(bottom: 0))
  }
}

// MARK: - Action
extension FavoriteViewController {
  @objc func didTapSettingButton() {
    print("DEBUG: Tap setting button")
    // 여기서 테스트로 feed 함 가보자. 네비 선 사라지나 안사라지나 ,.,.,
    
  }
}
