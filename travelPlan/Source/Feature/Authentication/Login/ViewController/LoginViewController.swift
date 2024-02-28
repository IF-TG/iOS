//
//  LoginViewController.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/25.
//

import UIKit
import Combine
import AuthenticationServices

final class LoginViewController: UIViewController {
  // MARK: - Properteis
  var vm: LoginViewModel!
  private var subscriptions = Set<AnyCancellable>()
  weak var coordinator: LoginCoordinatorDelegate?
  
  private lazy var loginView = LoginView().set {
    $0.delegate = self
  }
  private let input = LoginViewModel.Input()
  private let loginPlayerSupporter = LoginPlayerSupporter()
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    configureVideo()
    setupUI()
    setupStyles()
    bind()
    input.viewDidLoad.send()
  }
  
  private override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }
  
  convenience init(vm: LoginViewModel) {
    self.init(nibName: nil, bundle: nil)
    self.vm = vm
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    input.viewWillAppear.send()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    navigationController?.navigationBar.isHidden = false
  }
  
  deinit {
    coordinator?.finish()
  }
}

// MARK: - ViewBindCaes
extension LoginViewController: ViewBindCase {
  typealias Input = LoginViewModel.Input
  typealias ErrorType = LoginViewModel.ErrorType
  typealias State = LoginViewModel.State
  
  func bind() {
    let output = vm.transform(input)
    output.sink { [weak self] completion in
      switch completion {
      case .finished: 
        break
      case .failure(let error):
        self?.handleError(error)
      }
    } receiveValue: { [weak self] in
      self?.render($0)
    }.store(in: &subscriptions)
    
  }
  
  func render(_ state: State) {
    switch state {
    case .none:
      print("none")
    case .appear:
      print("appear")
    case .viewLoad:
      print("viewLoaded")
    case .presentKakao:
      // TODO: - 카카오 연동 후 인증된 후에 피드로가야합니다. 지금은 바로 갑니다.
      coordinator?.showFeedPage()
    case .presentApple:
      print("Apple 로그인 화면 띄워짐")
    case .presentGoogle:
      print("Google 로그인 화면 띄워짐")
    }
  }
  
  func handleError(_ error: ErrorType) {
    switch error {
    case .none:
      print("none")
    case .unexpectedError:
      print("unexpectedError")
    }
  }
}

// MARK: - Helpers
extension LoginViewController {
  func resumeVideo() {
    loginPlayerSupporter.play()
  }
}

// MARK: - Private Helpers
extension LoginViewController {
  private func configureVideo() {
    loginPlayerSupporter.setupPlayer(in: self.view)
    loginPlayerSupporter.play()
  }
  
  private func setupStyles() {
    navigationController?.navigationBar.isHidden = true
    view.backgroundColor = .white
  }
}

// MARK: - LayoutSupport
extension LoginViewController: LayoutSupport {
  func addSubviews() {
    view.addSubview(loginView)
  }
  
  func setConstraints() {
    loginView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
}

extension LoginViewController: LoginButtonDelegate {
  func loginButton(_ button: UIButton) {
    if button is KakaoLoginButton {
      input.didTapKakaoButton.send()
    } else if button is AppleLoginButton {
      input.didTapAppleButton.send()
      
      let idProvider = ASAuthorizationAppleIDProvider()
      let request = idProvider.createRequest()
      request.requestedScopes = [.fullName, .email]
      
      let authorizationController = ASAuthorizationController(authorizationRequests: [request])
      authorizationController.delegate = self
      authorizationController.presentationContextProvider = self
      authorizationController.performRequests()
      
    } else if button is GoogleLoginButton {
      input.didTapGoogleButton.send()
    }
  }
}

// MARK: - ASAuthorizationControllerDelegate
extension LoginViewController: ASAuthorizationControllerDelegate {
  func authorizationController(
    controller: ASAuthorizationController,
    didCompleteWithAuthorization authorization: ASAuthorization
  ) {
    if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
      if let authorizationCode = credential.authorizationCode,
         let identityToken = credential.identityToken {
        let authString = authorizationCode.base64EncodedString()
        let tokenString = identityToken.base64EncodedString()
        input.didCompleteWithAuthorization.send((authString, tokenString))
        // TODO: - 백엔드에게 authCode, identityCode 전송해서 accessToken, refreshToken 받아오기
      }
    }
  }
  
  func authorizationController(
    controller: ASAuthorizationController,
    didCompleteWithError error: Error
  ) {
    
  }
}

// MARK: - ASAuthorizationControllerPresentationContextProviding
extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
  func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
    return self.view.window!
  }
}
