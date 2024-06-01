//
//  AppDelegate.swift
//  travelPlan
//
//  Created by 양승현 on 2023/04/29.
//

import UIKit
import FirebaseCore
import GoogleSignIn
import AppsFlyerLib

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Override point for customization after application launch.
    FirebaseApp.configure()
    configureAppsFlyer()
    return true
  }

  // MARK: UISceneSession Lifecycle

  func application(
    _ application: UIApplication,
    configurationForConnecting connectingSceneSession: UISceneSession,
    options: UIScene.ConnectionOptions
  ) -> UISceneConfiguration {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }

  func application(
    _ application: UIApplication,
    didDiscardSceneSessions sceneSessions: Set<UISceneSession>
  ) {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
  }
  
  // MARK: - Open Universal Links
  /// Universal link에 의해 시스템에서 여가 앱이 열린다면 이 함수가 호출됩니다.
  /// userActivity에 AppsFlyer 에서 onelink로 제어하도록 합니다.
  func application(
    _ application: UIApplication,
    continue userActivity: NSUserActivity,
    restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void
  ) -> Bool {
    AppsFlyerLib.shared().continue(userActivity, restorationHandler: nil)
    return true
  }
  
  /// iOS9 이상부터 가능합니다.
  /// 다른 앱 아니면 시스템으로부터 URL scheme으로 열 때 호출됩니다.
  func application(
    _ app: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey: Any] = [:]
  ) -> Bool {
    AppsFlyerLib.shared().handleOpen(url, options: options)
    let gidSignInHandled = GIDSignIn.sharedInstance.handle(url)
    return gidSignInHandled
  }
  
  // Report Push Notification attribution data for re-engagements
  func application(
    _ application: UIApplication,
    didReceiveRemoteNotification userInfo: [AnyHashable: Any],
    fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
  ) {
    AppsFlyerLib.shared().handlePushNotification(userInfo)
  }
}

// MARK: - DeepLinkDelegate
extension AppDelegate: DeepLinkDelegate {
  func didResolveDeepLink(_ result: DeepLinkResult) {
    switch result.status {
    case .notFound:
      NSLog("[AFSDK] Deep link not found")
      return
    case .failure:
      print("Error %@", result.error!)
      return
    case .found:
      NSLog("[AFSDK] Deep link found")
    }
    guard let deepLinkObj: DeepLink = result.deepLink else {
      NSLog("[AFSDK] Could not extract deep link object")
      return
    }
    
    #if DEBUG
    let deepLinkStr: String = deepLinkObj.toString()
    NSLog("[AFSDK] DeepLink data is: \(deepLinkStr)")
    #endif
    
    let relativePath = deepLinkObj.clickEvent["path"]
    let postId = extractPostId(from: relativePath as? String)
    
    goToPostDetailScene(with: postId)
  }
}

// MARK: - AppsFlyerLibDelegate
extension AppDelegate: AppsFlyerLibDelegate {
  // Handle Organic/Non-organic installation
  func onConversionDataSuccess(_ data: [AnyHashable: Any]) {
    print("onConversionDataSuccess data:")
    for (key, value) in data {
      print(key, ":", value)
    }
    
    if let status = data["af_status"] as? String {
      if status == "Non-organic" {
        if let sourceID = data["media_source"],
           let campaign = data["campaign"] {
          print("This is a Non-Organic install. Media source: \(sourceID)  Campaign: \(campaign)")
        }
      } else {
        print("This is an organic install.")
      }
      if let is_first_launch = data["is_first_launch"] as? Bool,
         is_first_launch {
        print("First Launch")
      } else {
        print("Not First Launch")
      }
    }
  }
  
  func onConversionDataFail(_ error: Error) {
    print("\(error)")
  }
}
