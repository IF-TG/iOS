//
//  ApplicationCoordinator.swift
//  travelPlan
//
//  Created by 양승현 on 2023/06/30.
//

import UIKit
import SHCoordinator

final class ApplicationCoordinator: FlowCoordinator {
  // MARK: - Properties
  var parent: FlowCoordinator?
  var child: [FlowCoordinator] = []
  var presenter: UINavigationController?
  var viewController: UIViewController?
  private let window: UIWindow
  
  private var isSignIn: Bool {
    // 로그인 확인TODO: - 추후 UserDefaults등으로 사용자 로그인 확인 후 로그인 or main coordinator로 전환.
    return UserDefaults.standard.bool(forKey: "isSignIn")
  }
  
  init(window: UIWindow) {
    self.window = window
  }
  
  func start() {
    // 루트 코디네이터는 parent가 nil 입니다.
    parent = nil
//    guard isSignIn else {
//      gotoLoginPage()
//      return
//    }
    gotoMainTapFeedPage()
  }
  
  func finish() {
    NSLog("DEBUG: App closed.")
  }
}

// MARK: - Setup other Coordinator
extension ApplicationCoordinator {
  
  /// - Param prevCoordinator : MainCoordinator에서 loginPage로 가야할 경우 MainCoordinator 삭제해야합니다.
  ///
  /// Notes:
  /// 1. MainCoordinator에서 login으로 가야할 때는 MainCoordinator를 삭제해야합니다.
  /// 2. app에서 시작될 때는 삭제해야할 prev coordinator가 없음으로 그냥 window에 등록합니다.
  func gotoLoginPage(withDelete prevCoordinator: MainCoordinator? = nil) {
    let loginCoordinator = LoginCoordinator(presenter: .init())
    window.rootViewController = nil
    window.rootViewController = loginCoordinator.presenter
    addChild(with: loginCoordinator)
    prevCoordinator?.finish()
  }
  
  func gotoMainTapFeedPage(withDelete prevCoordinator: LoginCoordinator? = nil) {
    let mainTabBarController = MainTabBarController()
    let mainCoordinator = MainCoordinator(
      mainTabBarViewController: mainTabBarController)
    window.rootViewController = nil
    window.rootViewController = mainCoordinator.mainTabBarPresenter
    addChild(with: mainCoordinator)
    prevCoordinator?.finish()
  }
}
