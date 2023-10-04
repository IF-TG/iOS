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
    case custom(imagePath: String, title: String, content: String)
  }
}
