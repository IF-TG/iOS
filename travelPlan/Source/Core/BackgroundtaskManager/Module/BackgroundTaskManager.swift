//
//  BackgroundTaskManager.swift
//  travelPlan
//
//  Created by 양승현 on 5/3/24.
//

import UIKit

/// Task!! if the app enters the background.
///
/// - URL: https://developer.apple.com/documentation/uikit/uiapplication/1623031-beginbackgroundtask#return_value
///
///  Notes:
/// 1. 백그라운드로 전환되더라도 이 작업은 꼭 마쳐야겠다 싶을때 사용합시닷 :  ]
public final class BackgroundTaskManager {
  // MARK: - Properties
  static let shared = BackgroundTaskManager()
  
  private init() {}
}

// MARK: - Public Helpers
public extension BackgroundTaskManager {
  func startBackgroundTask() -> UIBackgroundTaskIdentifier {
    let identifier = UIApplication.shared.beginBackgroundTask { [weak self] in
      self?.endBackgroundTask(identifier)
    }
    return identifier
  }
  
  func endBackgroundTask(_ identifier: UIBackgroundTaskIdentifier) {
    UIApplication.shared.endBackgroundTask(identifier)
  }
}
