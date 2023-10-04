//
//  EmptyStateView.swift
//  travelPlan
//
//  Created by 양승현 on 10/4/23.
//

import UIKit

final class EmptyStateView: UIView {
  enum UseageType {
    case emptyNotifiation
    case disabledNotification
    case emptyTravelPost
    case emptyTravelLocation
    case customEmpty(imagePath: String, title: String, content: String)
    
    var iconPath: String {
      switch self {
      case .emptyNotifiation:
        return "emptyNotificationBell"
      case .disabledNotification:
        return "disabledNotificationBell"
      case .emptyTravelPost:
        return "emptyStateStar"
      case .emptyTravelLocation:
        return "emptyStateStar"
      case .customEmpty(let path, _, _):
        return path
      }
    }
    
    var titleFont: UIFont {
      return .systemFont(ofSize: 15, weight: .init(600))
    }
    
    var contentFont: UIFont {
      return .systemFont(ofSize: 13, weight: .init(400))
    }
    
    var textColor: UIColor {
      return .YG.gray1
    }
  }
}
