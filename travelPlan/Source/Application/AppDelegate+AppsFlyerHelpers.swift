//
//  AppDelegate+AppsFlyerHelpers.swift
//  travelPlan
//
//  Created by 양승현 on 5/29/24.
//

import UIKit
import AppsFlyerLib

extension AppDelegate {
  internal func configureAppsFlyer() {
    guard
      let appsFlyerDevKey = SecretManager.shared.get(with: .appsFlyerDevKey),
      let appleAppID = SecretManager.shared.get(with: .appleAppId)
    else { fatalError("Cannot find `appsFlyerDevKey` or `appleAppID` key") }
    
    AppsFlyerLib.shared().appsFlyerDevKey = appsFlyerDevKey
    AppsFlyerLib.shared().appleAppID = appleAppID
    
    #if DEBUG
    AppsFlyerLib.shared().isDebug = true
    #endif
    
    AppsFlyerLib.shared().delegate = self
    AppsFlyerLib.shared().deepLinkDelegate = self
    
    // - Subscribe to didBecomeActiveNotification if you use SceneDelegate or just call
    // -[AppsFlyerTracker trackAppLaunch] from -[AppDelegate applicationDidBecomeActive:]
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(didBecomeActiveNotification),
      name: UIApplication.didBecomeActiveNotification,
      object: nil)
  }
  
  func goToPostDetailScene(with postId: UserIdentifier?) {
    guard
      let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
      let sceneDelegate = windowScene.delegate as? SceneDelegate
    else { return }
          
    sceneDelegate.appCoordinator?.gotoFeedDetailByUniversalLink(with: postId)
  }
}

extension AppDelegate {
  @objc func didBecomeActiveNotification() {
    AppsFlyerLib.shared().start()
  }
}
