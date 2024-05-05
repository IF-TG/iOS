//
//  LoginCoordinator.swift
//  travelPlan
//
//  Created by 양승현 on 2023/06/30.
//

import UIKit
import SHCoordinator
import SHFirestoreService

protocol LoginCoordinatorDelegate: FlowCoordinatorDelegate {
  func showFeedPage()
}

final class LoginCoordinator: FlowCoordinator {
  // MARK: - Properties
  var parent: FlowCoordinator?
  var child: [FlowCoordinator] = []
  let presenter: UINavigationController?
  weak var viewController: UIViewController?

  // MARK: - Lifecycle
  init(presenter: UINavigationController?) {
    self.presenter = .init()
  }
  
  func start() {
    let json = """
      {
        "accessToken": "StringAbc",
        "refreshToken": "StringAbcd",
        "accessTokenExpiresIn": 3600000,
        "refreshTokenExpiresIn": 1200000000
      }
    """
    MockUrlProtocol.requestHandler = { _ in
      let responseData = json.data(using: .utf8)!
      return ((HTTPURLResponse(), responseData))
    }
    
    let mockSession = MockSession.default
    let sessionProvider = SessionProvider(session: mockSession)
    let authService = DefaultAuthenticationService(sessionProvider: sessionProvider)
    let loginResultStorage = UserDefaultsLoginResultStorage()
    
    let storage = UserDefaultsUserStorage()
    let loggedInUserRepository = DefaultLoggedInUserRepository(storage: storage)
    let userProfileRepository = FirestoreUserProfileRepository(
      service: FirestoreService(),
      firebaseStorageService: FirebaseStorageService())
    let repository = DefaultLoginRepository(
      authService: authService,
      loginResultStorage: loginResultStorage,
      loggedInUserRepository: loggedInUserRepository, 
      userProfileRepository: userProfileRepository,
      firestoreService: FirestoreService())
    let useCase = DefaultLoginUseCase(loginRepository: repository)
    let loginVM = LoginViewModel(loginUseCase: useCase)
    let loginViewController = LoginViewController(viewModel: loginVM)
    viewController = loginViewController
    loginViewController.coordinator = self
    presenter?.viewControllers = [loginViewController]
  }
  
  deinit {
    print("삭제요~ \(Self.self)")
  }
}

// MARK: - LoginCoordinatorDelegate
extension LoginCoordinator: LoginCoordinatorDelegate {
  func showFeedPage() {
    guard let parent = parent as? ApplicationCoordinator else {
      NSLog("DEBUG: Parent is not applicationCoordinator")
      return
    }
    parent.gotoMainTapFeedPage(withDelete: self)
  }
}
