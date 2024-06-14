//
//  SceneDelegate.swift
//  travelPlan
//
//  Created by 양승현 on 2023/04/29.
//

import UIKit
import AppsFlyerLib

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  /// 이 객체를 참조하지 않아도 되지만, 앱스플라이어에서는 AppDelegate에서 one link를 처리하기에 이 객체 인스턴스를 선언했습니다..
  private(set) var appCoordinator: ApplicationCoordinator?

  private(set) var appDIContainer = AppDIContainer.shared
  
  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    appDIContainer.lazyApplyAssemblies()
    guard let windowScene = (scene as? UIWindowScene) else { return }
    let window = UIWindow(windowScene: windowScene)
    
    appCoordinator = ApplicationCoordinator(window: window, dependencies: appDIContainer)
    appCoordinator?.start()
    window.makeKeyAndVisible()
    
    if #available(iOS 13.0, *) {
      window.overrideUserInterfaceStyle = .light
    }
    
    if let userActivity = connectionOptions.userActivities.first {
      AppsFlyerLib.shared().continue(userActivity, restorationHandler: nil)
    } else if let url = connectionOptions.urlContexts.first?.url {
      if url.scheme == "https" || url.scheme == "http" {
        AppsFlyerLib.shared().handleOpen(url, options: nil)
      } else {
        /// 일반 URL 스킴. 그러나 유니버셜 링크 사용해서 사용X.
        /// 그러나 앱이 종료된후에 여기에도 동일하게 handleOpen(url:options:)를 호출해서 앱 델리게이트의 포스트 상세화면으로
        /// 갈 수있게 호출을 해주어야 합니다.
        AppsFlyerLib.shared().handleOpen(url, options: nil)
      }
    }
  }
  
  /// universal link에 의해 켜져있다가 background -> foreground로 오는 경우
  func scene(
    _ scene: UIScene,
    continue userActivity: NSUserActivity
  ) {
    AppsFlyerLib.shared().continue(userActivity, restorationHandler: nil)
  }
  
  /// URLSceme, universal link
  func scene(
    _ scene: UIScene,
    openURLContexts URLContexts: Set<UIOpenURLContext>
  ) {
    // URI scheme - Background -> foreground
    if let url = URLContexts.first?.url {
      AppsFlyerLib.shared().handleOpen(url, options: nil)
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
