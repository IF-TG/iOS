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
      let propertiesPath = Bundle.main.path(forResource: "afdevkey_donotpush", ofType: "plist"),
      let properties = NSDictionary(contentsOfFile: propertiesPath) as? [String:String] 
    else { fatalError("Cannot find `afdevkey_donotpush`") }
    guard
      let appsFlyerDevKey = properties["appsFlyerDevKey"],
      let appleAppID = properties["appleAppID"] 
    else { fatalError("Cannot find `appsFlyerDevKey` or `appleAppID` key") }
    
    AppsFlyerLib.shared().appsFlyerDevKey = SecretManager.shared.get(with: .appsFlyerDevKey)!
    AppsFlyerLib.shared().appleAppID = SecretManager.shared.get(with: .appleAppId)!
    
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
    
    // TODO: - 앱 최초 실행일 경우 신 델리게이트 -> 앱 델리게이트 호출이어서, 여기서 이제 신 델리게이트에서 내부에 앱코디 변수 추가하고
    // 공유하기에의해들어올떄 로직도 추가해주자.
  }
}

extension AppDelegate {
  @objc func didBecomeActiveNotification() {
    AppsFlyerLib.shared().start()
  }
}
