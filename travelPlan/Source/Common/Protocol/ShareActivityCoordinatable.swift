//
//  ShareActivityCoordinatable.swift
//  travelPlan
//
//  Created by 양승현 on 6/15/24.
//

import UIKit
import SHCoordinator

/// ActivityViewController의 화면 전환을 제어하는 코드 중복 최소화를 위한 프로토콜입니다.
protocol ShareActivityCoordinatable { }

extension ShareActivityCoordinatable where Self: FlowCoordinator {
  func showActivitySheet(with activityItems: [Any], applicationActivities: [UIActivity]? = nil) {
    let activityViewController = UIActivityViewController(
      activityItems: activityItems,
      applicationActivities: nil)
    
    presenter?.visibleViewController?.present(activityViewController, animated: true)
  }
}
