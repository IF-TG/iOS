//
//  LoginViewController.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/25.
//

import UIKit
import Combine
import AVFoundation

class LoginViewController: UIViewController {
  enum Constant {
    static let bundleResource = "onboarding-video"
    static let bundleExtension = "mp4"
  }
  
  // MARK: - Properteis
  var vm: LoginViewModel!
  private var subscriptions = Set<AnyCancellable>()
  weak var coordinator: LoginCoordinatorDelegate?
  
  private var player: AVPlayer!
  private var playerLayer: AVPlayerLayer!
  
  private lazy var loginView = LoginView().set {
    $0.delegate = self
  }
  private let input = LoginViewModel.Input()
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupPlayer()
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
      case .finished: break
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
      print("Kakao 로그인 화면 띄워짐")
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

// MARK: - Private Helpers
extension LoginViewController {
  private func setupStyles() {
    navigationController?.navigationBar.isHidden = true
    view.backgroundColor = .white
  }
  
  private func setupPlayer() {
    typealias Const = Constant
    guard let url = Bundle.main.url(forResource: Const.bundleResource,
                                    withExtension: Const.bundleExtension) else { return }
    self.player = AVPlayer(playerItem: AVPlayerItem(url: url))
    self.playerLayer = AVPlayerLayer(player: player)
    
    playerLayer.frame = view.bounds
    playerLayer.videoGravity = .resizeAspectFill
    view.layer.addSublayer(playerLayer)
    
    // 비디오가 끝나면 비디오를 다시 처음부터 재시작합니다.
    NotificationCenter.default.publisher(
      for: AVPlayerItem.didPlayToEndTimeNotification,
      object: self.player.currentItem
    )
    .sink { [weak self] _ in
      self?.player.seek(to: CMTime.zero, completionHandler: { isCompleted in
        if isCompleted {
          self?.player.play()
        }
      })
    }
    .store(in: &subscriptions)
    
    player.play()
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
    } else if button is GoogleLoginButton {
      input.didTapGoogleButton.send()
    }
  }
}
