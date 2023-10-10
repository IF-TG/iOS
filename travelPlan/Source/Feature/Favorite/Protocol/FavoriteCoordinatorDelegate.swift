//
//  FavoriteCoordinatorDelegate.swift
//  travelPlan
//
//  Created by 양승현 on 10/11/23.
//

import Foundation

protocol FavoriteCoordinatorDelegate: AnyObject {
  func finish()
  func showDetailPage(with id: AnyHashable)
  func showNewDirectoryCreationPage()
  func showDirectoryNameSettingPage(with index: Int)
}
