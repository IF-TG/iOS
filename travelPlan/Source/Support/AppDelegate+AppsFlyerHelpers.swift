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
  
  func goToPostDetailScene(with postId: Int32?) {
    guard
      let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
      let sceneDelegate = windowScene.delegate as? SceneDelegate
    else { return }
          
    sceneDelegate.appCoordinator?.gotoFeedDetailByUniversalLink(with: postId)
  }
  
  /// Universal link의 url의 링크에 도메인을 제외한 path를 받으면, postId를 찾아 반환합니다.
  func extractPostId(from path: String?) -> Int32? {
    guard let path = path else {
      return nil
    }
    let parameters = path.split { $0=="/" }
    /// 포스트아이디 위치 다음 parameter가 존재하는가?
    if let postIdIndex = parameters.firstIndex(of: "postId"), postIdIndex + 1 < parameters.count {
      let postId = parameters[postIdIndex + 1]
      return Int32(postId)
    }
    return nil
  }
}

extension AppDelegate {
  @objc func didBecomeActiveNotification() {
    AppsFlyerLib.shared().start()
  }
}
