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
  // MARK: - Properteis
  var vm: LoginViewModel!
  let appear = PassthroughSubject<Void, ErrorType>()
  let viewLoad = PassthroughSubject<Void, ErrorType>()
  private var subscriptions = Set<AnyCancellable>()
  weak var coordinator: LoginCoordinatorDelegate?
  
  private var player: AVPlayer!
  private var playerLayer: AVPlayerLayer!
  
  private let loginStartView = LoginStartView()
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupPlayer()
    setupUI()
    bind()
    setupStyles()
    
    viewLoad.send()
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
    appear.send()
  }
  
  deinit {
    coordinator?.finish()
  }
}

// MARK: - ViewBindCase
extension LoginViewController: ViewBindCase {
  typealias Input = LoginViewModel.Input
  typealias ErrorType = LoginViewModel.ErrorType
  typealias State = LoginViewModel.State
  
  func bind() {
    let input = Input(
      appear: appear.eraseToAnyPublisher(),
      viewLoad: viewLoad.eraseToAnyPublisher())
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
    }
  }
  
  func handleError(_ error: LoginViewModel.ErrorType) {
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
    view.backgroundColor = .white
  }
  
  private func setupPlayer() {
    guard let url = Bundle.main.url(forResource: "onboarding-video", withExtension: "mp4") else { return }
    self.player = AVPlayer(playerItem: AVPlayerItem(url: url))
    self.playerLayer = AVPlayerLayer(player: player)
    
    playerLayer.frame = view.bounds
    playerLayer.videoGravity = .resizeAspectFill
    view.layer.addSublayer(playerLayer)
    
    NotificationCenter.default.publisher(
      for: AVPlayerItem.didPlayToEndTimeNotification,
      object: self.player.currentItem
    )
    .sink { [weak self] _ in
      // CMTime.zero: 비디오의 시작점
      self?.player.seek(to: CMTime.zero, completionHandler: { isSeekingCompelete in
        if isSeekingCompelete {
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
    view.addSubview(loginStartView)
  }
  
  func setConstraints() {
    loginStartView.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.bottom.equalToSuperview().inset(60)
      $0.width.equalTo(70)
      $0.height.equalTo(125)
    }
  }
}
