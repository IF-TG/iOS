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
    let appCoordinator = ApplicationCoordinator(window: window)
    appCoordinator.start()
    window.makeKeyAndVisible()
  }
}

extension SceneDelegate {
  func sceneDidDisconnect(_ scene: UIScene) {}
  func sceneDidBecomeActive(_ scene: UIScene) {}
  func sceneWillResignActive(_ scene: UIScene) {}
  func sceneWillEnterForeground(_ scene: UIScene) {}
  func sceneDidEnterBackground(_ scene: UIScene) {}
}
