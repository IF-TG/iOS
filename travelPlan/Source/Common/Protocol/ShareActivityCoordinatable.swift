//
//  ShareActivityCoordinatable.swift
//  travelPlan
//
//  Created by 양승현 on 6/15/24.
//

import UIKit
import SHCoordinator

protocol ShareActivityCoordinatable {
  func showActivitySheetForShare(with activityItems: [Any])
}

extension ShareActivityCoordinatable where Self: FlowCoordinator {
  func showActivitySheet(with activityItems: [Any]) {
    let activityViewController = UIActivityViewController(
      activityItems: activityItems,
      applicationActivities: nil)
    
    presenter?.visibleViewController?.present(activityViewController, animated: true)
  }
}
