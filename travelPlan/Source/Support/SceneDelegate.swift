//
//  SceneDelegate.swift
//  travelPlan
//
//  Created by 양승현 on 2023/04/29.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    let window = UIWindow(windowScene: windowScene)
    ApplicationCoordinator(window: window).set { $0.start() }
    window.makeKeyAndVisible()
  }
}
