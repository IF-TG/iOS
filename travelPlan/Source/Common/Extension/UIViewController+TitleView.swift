//
//  UIViewController+TitleView.swift
//  travelPlan
//
//  Created by SeokHyun on 10/12/23.
//

import UIKit

extension UIViewController {
  /// 내비게이션의 titleView를 설정합니다.
  ///
  /// 인자로 type을 지정합니다.
  /// default의 경우, titleString을 넣어줍니다.
  /// custom의 경우, 커스텀 UIView를 넣어줍니다.
  func setupBaseNavigationTitleView(titleViewType: BaseNavigationTitleView.`Type`) {
    self.navigationItem.titleView = BaseNavigationTitleView(type: titleViewType)
  }
}
