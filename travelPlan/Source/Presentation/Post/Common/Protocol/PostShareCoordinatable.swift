//
//  PostShareCoordinatable.swift
//  travelPlan
//
//  Created by 양승현 on 6/15/24.
//

import UIKit
import SHCoordinator

protocol PostShareCoordinatable: ShareActivityCoordinatable {
  func showPostShareSheet(with activityItem: PostActivityItemSource)
}

extension PostShareCoordinatable where Self: FlowCoordinator {
  func showPostShareSheet(with activityItem: PostActivityItemSource) {
    showActivitySheet(with: [activityItem], applicationActivities: nil)
  }
}
