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
  
  func goToPostDetailScene(with PostId: String) {
    print("hi")
    // TODO: - 앱 최초 실행일 경우 신 델리게이트 -> 앱스플라이어에 의해 앱 델리게이트 호출이어서, 여기서 이제 신 델리게이트에서 내부에 앱코디 변수
    // 추가하고
    // 공유하기에의해들어올떄 로직도 추가해주자.
  }
  
  /// Universal link의 url의 링크에 도메인을 제외한 path를 받으면, postId를 찾아 반환합니다.
  func extractPostId(from path: String?) -> Int? {
    guard let path = path else {
      return nil
    }
    let parameters = path.split { $0=="/" }
    /// 포스트아이디 위치 다음 parameter가 존재하는가?
    if let postIdIndex = parameters.firstIndex(of: "postId"), postIdIndex + 1 < parameters.count {
      let postId = parameters[postIdIndex + 1]
      return Int(postId)
    }
    return nil
  }
}

extension AppDelegate {
  @objc func didBecomeActiveNotification() {
    AppsFlyerLib.shared().start()
  }
}
