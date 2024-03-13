//
//  LoginViewController.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/25.
//

import UIKit
import Combine

final class LoginViewController: UIViewController {
  // MARK: - Properteis
  var viewModel: LoginViewModel!
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
  }
  
  init(viewModel: LoginViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    navigationController?.navigationBar.isHidden = false
  }
  
  deinit {
    print("deinit: \(Self.self)")
    coordinator?.finish()
  }
}

// MARK: - ViewBindCaes
extension LoginViewController: ViewBindCase {
  typealias Input = LoginViewModel.Input
  typealias ErrorType = LoginViewModel.ErrorType
  typealias State = LoginViewModel.State
  
  func bind() {
    let output = viewModel.transform(input)
    output.sink { completion in
      switch completion {
      case .finished: 
        break
      case .failure(let error):
        break
      }
    } receiveValue: { [weak self] in
      self?.render($0)
    }.store(in: &subscriptions)
    
  }
  
  func render(_ state: State) {
    switch state {
    case .presentFeed:
      coordinator?.showFeedPage()
    case .none:
      break
    }
  }
  
  func handleError(_ error: ErrorType) { }
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
      print("DEBUG: 로그인 기능이 아직 구현되지 않았습니다.")
//      input.didTapLoginButton.send(.kakao)
    } else if button is AppleLoginButton {
      input.didTapLoginButton.send(.apple)
    } else if button is GoogleLoginButton {
      print("DEBUG: 로그인 기능이 아직 구현되지 않았습니다.")
//      input.didTapLoginButton.send(.google)
    }
  }
}
