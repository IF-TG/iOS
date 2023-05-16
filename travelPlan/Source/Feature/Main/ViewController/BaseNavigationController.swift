//
//  BaseNavigationController.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/05/15.
//

// import UIKit

/*
 default
 1. '<' (back Indicator Image)
 2. 'Back' (back Bar Button Item)
 두 개로 이루어져 있습니다.
 */

// class BaseNavigationController: UINavigationController {
  // MARK: - Properties
//  private var backButtonAppearance: UIBarButtonItemAppearance {
//    let backButtonAppearance = UIBarButtonItemAppearance()
//    // backButton하단에 표출되는 text를 안보이게 설정
//    backButtonAppearance.normal.titleTextAttributes = [
//      .foregroundColor: UIColor.clear,
//      .font: UIFont.systemFont(ofSize: 0.0)
//    ]
//
//    return backButtonAppearance
//  }

//  private static let paddingBarButtonItem: UIBarButtonItem = {
//      let spaceBarButtonItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
//      spaceBarButtonItem.width = 11 // 11만큼 왼쪽 버튼과 여백
//
//      return spaceBarButtonItem
//  }()

  // MARK: - LifeCycle
//  override func viewDidLoad() {
//    super.viewDidLoad()
//    setNavigationBarAppearance()
//  }
// }

// MARK: - Helpers
// extension BaseNavigationController {
//  private func setNavigationBarAppearance() {
//    let appearance = UINavigationBarAppearance()
//    appearance.backgroundColor = .white
//    appearance.shadowColor = .clear
//
////    let image = UIImage(named: "back.button")?.withRenderingMode(.alwaysOriginal)
////    appearance.setBackIndicatorImage(image, transitionMaskImage: image)
////    appearance.backButtonAppearance = backButtonAppearance
//
//    self.navigationBar.standardAppearance = appearance
//    self.navigationBar.compactAppearance = appearance
//    self.navigationBar.scrollEdgeAppearance = appearance
//    self.navigationBar.isTranslucent = false
//    // navigationItem의 버튼 색상을 .white로 지정
////    self.navigationBar.tintColor = .yg
//
//    // Default: Back Indicator Image
//
//  }
// }

// 1. rightBarButtonItem을 설정
// 2.
