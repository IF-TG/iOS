//
//  ApplicationCoordinator.swift
//  travelPlan
//
//  Created by 양승현 on 2023/06/30.
//

import UIKit
import SHCoordinator

protocol ApplicationDependencies {
  func makeMainCoordinator() -> MainCoordinator
  func makeLoginCoordinator() -> LoginCoordinator
}

final class ApplicationCoordinator: FlowCoordinator {
  // MARK: - Properties
  var parent: FlowCoordinator?
  var child: [FlowCoordinator] = []
  var presenter: UINavigationController?
  var viewController: UIViewController?
  private let loggedInOwnerManager = DefaultLoggedInUserUseCase(
    loggedInUserRepository: DefaultLoggedInUserRepository(
      storage: UserDefaultsOwnerStorage()))
  private let window: UIWindow
  
  private let dependencies: ApplicationDependencies
  
  private var isSignIn: Bool {
    return true
//    로그인 할 경우 이를 통해 사용자가 로그인했는지 여부를 확인해야합니다.
//    if loggedInOwnerManager.user == nil {
//      return false
//    }
// return true
  }
  
  init(window: UIWindow, dependencies: ApplicationDependencies) {
    self.window = window
    self.dependencies = dependencies
  }
  
  func start() {
    // 루트 코디네이터는 parent가 nil 입니다.
    parent = nil
    guard isSignIn else {
      gotoLoginPage()
      return
    }
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
  func gotoLoginPage(withDelete prevCoordinator: MainCoordinator? = nil, alertMessage: String? = nil) {
    let loginCoordinator = dependencies.makeLoginCoordinator()
    window.rootViewController = nil
    window.rootViewController = loginCoordinator.presenter
    addChild(with: loginCoordinator)
    prevCoordinator?.finish()
  }
  
  func gotoMainTapFeedPage(withDelete prevCoordinator: LoginCoordinator? = nil) {
    let mainCoordinator = dependencies.makeMainCoordinator()
    window.rootViewController = nil
    window.rootViewController = mainCoordinator.tabBarController
    addChild(with: mainCoordinator)
    prevCoordinator?.finish()
  }
  
  /// universal link로 들어온 경우 ( 공유하기 )
  /// 로그인하지 않은 경우 로그인 화면으로,
  /// 로그인한 사용자인 경우 상세 화면으로 전환합니다.
  func gotoFeedDetailByUniversalLink(with postId: Int32?) {
    guard isSignIn else {
      gotoLoginPage(alertMessage: "로그인을 하셔야 앱을 이용할 수 있습니다.")
      return
    }
    if child.isEmpty {
      gotoMainTapFeedPage()
    }
    let mainCoordinator = child.first as? MainCoordinator
    
    guard let postId = postId else {
      mainCoordinator?.showAlertInFeed(title: "요청 실패", message: "유효하지 않은 포스트입니다.")
      return
    }
    mainCoordinator?.showFeedDetail(with: postId)
  }
}
