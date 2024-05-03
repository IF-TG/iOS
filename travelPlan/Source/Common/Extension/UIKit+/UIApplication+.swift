//
//  UIApplication+.swift
//  travelPlan
//
//  Created by 양승현 on 5/2/24.
//

import UIKit.UIApplication

public extension UIApplication {
  /// 앱에서 최상위로 표시된 뷰 컨트롤러를 반환합니다.
  static var topPresentedViewController: UIViewController? {
    var presentedVC: UIViewController?

    if #available(iOS 15.0, *) {
      let rootVC = shared
        .connectedScenes
        .filter { $0.activationState == .foregroundActive }
        .first(where: {$0 is UIWindowScene })
        .flatMap { $0 as? UIWindowScene }?.windows
        .first(where: \.isKeyWindow)?.rootViewController
      
      if let rootVC = rootVC {
        presentedVC = rootVC
      }
      
    } else if #available(iOS 13.0, *) {
      if let window = shared.windows.first(where: { $0.isKeyWindow }),
         let viewController = window.rootViewController?.presentedViewController {
        presentedVC = viewController
      }
    } else {
      presentedVC = shared.keyWindow?.rootViewController?.presentedViewController
    }
    
    return presentedVC
  }
}
