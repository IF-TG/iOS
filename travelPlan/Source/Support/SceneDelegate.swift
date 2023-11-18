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
    
    if #available(iOS 13.0, *) {
      window.overrideUserInterfaceStyle = .light
    }
  }
  
  func sceneWillEnterForeground(_ scene: UIScene) {
    resumeLoginVideo(scene)
  }
}

// MARK: - Private Helpers
extension SceneDelegate {
  private func resumeLoginVideo(_ scene: UIScene) {
    guard let windowScene = scene as? UIWindowScene,
          let rootViewController = windowScene.windows.first?.rootViewController as? UINavigationController,
          let loginViewController = rootViewController.topViewController as? LoginViewController
    else { return }
    
    loginViewController.resumeVideo()
  }
}
