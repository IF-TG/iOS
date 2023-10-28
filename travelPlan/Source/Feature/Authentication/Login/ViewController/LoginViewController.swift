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
  
  private let yeogaLogo: UIImageView = .init().set {
    $0.image = UIImage(named: "yeoga-logo")?.withRenderingMode(.alwaysTemplate)
    $0.tintColor = .yg.littleWhite
  }
  private let airplaneLogo: UIImageView = .init().set {
    $0.image = UIImage(named: "airplane-logo")?.withRenderingMode(.alwaysTemplate)
    $0.contentMode = .scaleToFill
    $0.tintColor = .yg.primary
  }
  
  private let firstDescriptionLabel = UILabel().set {
    $0.font = .init(pretendard: .medium, size: 16)
    $0.textColor = .yg.littleWhite
    $0.text = "설레는 여행의 내딛음"
  }
  
  private lazy var loginDescriptionLabel = UILabel().set {
    $0.text = "설레는 여행의 내딛음,\n여행을 가다"
    $0.font = .init(pretendard: .medium, size: 20)
    $0.textColor = .yg.littleWhite
    $0.numberOfLines = 0
    
    setLoginDescriptionLabelAttributedText($0)
  }
  
  private let loginView = UIView().set {
    $0.backgroundColor = .clear
  }

  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupPlayer()
    setupUI()
    setupLoginUI()
    setupStyles()
    bind()
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
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    navigationController?.navigationBar.isHidden = false
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
  private func setLoginDescriptionLabelAttributedText(_ label: UILabel) {
    var paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineHeightMultiple = 1.2
    
    let attributedString = NSMutableAttributedString(
      string: label.text!,
      attributes: [.paragraphStyle: paragraphStyle]
    )
    
    let firstRange = (label.text! as NSString).range(of: "설레는 여행")
    let firstAttrs: [NSAttributedString.Key: Any] = [
      .font: UIFont(pretendard: .bold, size: 24) ?? .systemFont(ofSize: 24),
      .foregroundColor: UIColor.yg.littleWhite
    ]
    attributedString.addAttributes(firstAttrs, range: firstRange)
    
    let primaryAttrs: [NSAttributedString.Key: Any] = [
      .font: UIFont(pretendard: .bold, size: 24) ?? .systemFont(ofSize: 24),
      .foregroundColor: UIColor.yg.primary
    ]
    
    if let secondRange = (label.text! as NSString).range(of: "여행을").validation {
      let newRange = NSRange(location: secondRange.location, length: 2)
      attributedString.addAttributes(primaryAttrs, range: newRange)
    }
    
    let thirdRange = (label.text! as NSString).range(of: "가다")
    attributedString.addAttributes(primaryAttrs, range: thirdRange)
    
    label.attributedText = attributedString
  }
  
  private func setupLoginUI() {
    loginStartView.completionHandler = { [weak self] in
      UIView.animate(withDuration: 1, animations: {
        self?.loginView.backgroundColor = .black.withAlphaComponent(0.24)
        self?.loginStartView.alpha = 0
      }) { _ in
        self?.loginStartView.snp.removeConstraints()
        self?.loginStartView.removeFromSuperview()
        
        guard let self else { return }
        self.setupTopComponents()
        self.disappearFirstDescriptionLabel()
        
        UIView.animate(withDuration: 1) {
          self.loginView.layoutIfNeeded()
        }
      }
    }
  }
  
  private func setupTopComponents() {
    self.loginView.addSubview(self.loginDescriptionLabel)
    self.loginDescriptionLabel.snp.makeConstraints {
      $0.leading.equalToSuperview().inset(25)
      $0.top.equalTo(self.airplaneLogo.snp.bottom).offset(8)
    }
    
    self.airplaneLogo.snp.remakeConstraints {
      $0.top.equalTo(self.view.safeAreaLayoutGuide).inset(20)
      $0.leading.equalTo(self.loginDescriptionLabel.snp.trailing).offset(-20)
      $0.width.equalTo(48)
      $0.height.equalTo(30)
    }
    self.yeogaLogo.snp.remakeConstraints {
      $0.leading.equalToSuperview().inset(25)
      $0.top.equalTo(self.loginDescriptionLabel.snp.bottom).offset(20)
      $0.width.equalTo(125)
      $0.height.equalTo(47.5)
    }
  }
  
  private func disappearFirstDescriptionLabel() {
    UIView.animate(withDuration: 0.5,
                   animations: {
      self.firstDescriptionLabel.alpha = 0
    }) { _ in
      self.firstDescriptionLabel.snp.removeConstraints()
      self.firstDescriptionLabel.removeFromSuperview()
    }
  }
  
  private func setupStyles() {
    navigationController?.navigationBar.isHidden = true
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
    view.addSubview(loginView)
    loginView.addSubview(loginStartView)
    loginView.addSubview(airplaneLogo)
    loginView.addSubview(yeogaLogo)
    loginView.addSubview(firstDescriptionLabel)
  }
  
  func setConstraints() {
    loginView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    loginStartView.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.bottom.equalToSuperview().inset(60)
      $0.width.equalTo(70)
      $0.height.equalTo(LoginStartView.Constant.CircleView.size * 2.5 +
                        LoginStartView.Constant.CircleView.Spacing.leadingTrailingBottom)
    }
    
    airplaneLogo.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(50)
      $0.width.equalTo(48)
      $0.height.equalTo(30)
      $0.trailing.equalTo(yeogaLogo).offset(8)
    }
    
    yeogaLogo.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(airplaneLogo.snp.bottom).offset(10)
      $0.width.equalTo(125)
      $0.height.equalTo(47.5)
    }
    
    firstDescriptionLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(yeogaLogo.snp.bottom).offset(15)
    }
  }
}
