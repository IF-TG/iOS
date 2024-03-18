//
//  MyInformationViewController.swift
//  travelPlan
//
//  Created by 양승현 on 11/27/23.
//

import UIKit
import Combine

final class MyInformationViewController: UIViewController {
  // MARK: - Properties
  private lazy var profileImageView = SettingMyProfileView().set {
    $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapProfile)))
  }
  
  private let nicknameLabel = BaseLabel(fontType: .semiBold_600(fontSize: 18), lineHeight: 38).set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.text = "닉네임"
  }
  
  private lazy var inputNoticeLabel = BaseLabel(fontType: .medium_500(fontSize: 14)).set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.textAlignment = .right
  }
  
  private let inputTextField = SettingUserNameTextField().set {
    $0.placeholder = "닉네임을 입력해주세요"
  }
  
  private let connectedSNSLabel = BaseLabel(fontType: .semiBold_600(fontSize: 18), lineHeight: 38).set {
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  
  private let connectedSNSStackView = ConnectedSNSStackView()
  
  private lazy var logoutLabel = BaseLabel(fontType: .regular_400(fontSize: 14)).set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.text = "로그아웃"
    $0.textColor = .yg.gray3
    $0.sizeToFit()
    let rightLayer = CALayer()
    rightLayer.frame = CGRect(x: 0, y: $0.bounds.height-1, width: $0.bounds.width, height: 1)
    rightLayer.backgroundColor = UIColor.yg.gray3.cgColor
    $0.layer.addSublayer(rightLayer)
  }
  
  private let withdrawalLabel = BaseLabel(fontType: .regular_400(fontSize: 14), lineHeight: 46).set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.textColor = .yg.red2
    $0.text = "회원탈퇴"
  }
  
  private lazy var storeLabel = BaseLabel(fontType: .medium_500(fontSize: 16)).set {
    $0.text = "저장"
    $0.textColor = .yg.gray1
    $0.textAlignment = .right
    $0.isUserInteractionEnabled = false
    $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapStoreLabel)))
  }
  
  private var input = MyInformationViewModel.Input()
  
  private let viewModel: any MyInformationViewModelable
  
  private var subscriptions = Set<AnyCancellable>()
  
  private var errorHandler = PassthroughSubject<String, Never>()
  
  private var outputSubscription: AnyCancellable?
  
  private var errorSubscription: AnyCancellable?
  
  weak var coordinator: MyInformationCoordinatorDelegate?
  
  init(viewModel: any MyInformationViewModelable) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
    bindInputTextField()
    bindInputTextFieldTextState()
    bind()
    
    errorSubscription = errorHandler
      .subscribe(on: DispatchQueue.global(qos: .default))
      .receive(on: DispatchQueue.main)
      .sink { [weak self] errorDescription in
        self?.input = .init()
        self?.setStoreLabelAvailable()
        self?.coordinator?.showAlertForError(with: errorDescription, completion: {
          if self?.outputSubscription == nil {
            self?.bindInputTextField()
            self?.bindInputTextFieldTextState()
            self?.bind()
          }
        })
    }
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    if let touch = touches.first {
      let point = touch.location(in: view)
      guard inputTextField.isFirstResponder else { return }
      if !inputTextField.frame.contains(point) {
        inputTextField.resignFirstResponder()
      }
    }
  }
}

// MARK: - ViewBindCase
extension MyInformationViewController: ViewBindCase {
  typealias Input = MyInformationViewModel.Input
  typealias ErrorType = MyInforMationViewModelError
  typealias State = MyInformationViewModel.State
  
  func bind() {
    let output = viewModel.transform(input)
    outputSubscription = output
      .receive(on: DispatchQueue.main)
      .sink { [weak self] completion in
        self?.stopIndicator()
        switch completion {
        case .finished:
          break
        case .failure(let error):
          self?.handleError(error)
        }
      } receiveValue: { [weak self] state in
        self?.render(state)
      }
  }
  
  func render(_ state: MyInformationViewModel.State) {
    switch state {
    case .none:
      break
    case .correctionSaved:
      stopIndicator()
      setSubviewsDefaultUI()
    case .correctionNotSaved:
      coordinator?.showAlertForError(with: "저장에 실패했습니다", completion: nil)
      stopIndicator()
    case .networkProcessing:
      startIndicator()
    case .wannaLeaveThisPage(let hasUserEditedInfo):
      handleWhenUserWantToLeaveThisPage(with: hasUserEditedInfo)
    case .savableState(let isStateSavable):
      handleSavableState(isStateSavable)
    case .nicknameState(let state):
      inputTextField.textState = state
    }
  }
  
  func handleError(_ error: ErrorType) {
    outputSubscription = nil
    subscriptions = Set<AnyCancellable>()
    let errorDescription = switch error {
    case .userInformationNotFound(let description):
      description
    case .unknown(let description):
      description
    case .connectionError(let connectionError):
      connectionError.localizedDescription
    }
    errorHandler.send(errorDescription)
  }
}

// MARK: - Helpers
extension MyInformationViewController {
  func handleSelectedImage(with image: UIImage) {
    profileImageView.setImage(image)
    input.selectProfile.send(image.base64)
    let savableTextStates: [SettingUserNameTextField.State] = [.available, .default]
    if savableTextStates.contains(inputTextField.textState) {
      setStoreLabelAvailable()
    }
  }
}

// MARK: - Private Helpers
private extension MyInformationViewController {
  func bindInputTextField() {
    inputTextField.changed
      .sink { [weak self] text in
        self?.input.inputNickname.send(text)
      }.store(in: &subscriptions)
  }
  
  func bindInputTextFieldTextState() {
    inputTextField.$textState
      .receive(on: DispatchQueue.main)
      .sink { [weak self] state in
        if state == .available {
          self?.stopIndicator()
          self?.inputNoticeLabel.textColor = .yg.primary
          self?.inputNoticeLabel.text = self?.inputTextField.textState.quotation
          self?.setStoreLabelAvailable()
          return
        }
        if state == .default {
          self?.stopIndicator()
          self?.input.defaultNickname.send()
          return
        }
        if state == .duplicated {
          self?.stopIndicator()
        }
        // state가 duplicated, overflow, underflow인 경우
        self?.inputNoticeLabel.text = self?.inputTextField.textState.quotation
        self?.inputNoticeLabel.textColor = .yg.red2
        self?.setStoreLabelUnavailable()
      }.store(in: &subscriptions)
  }
  
  func setStoreLabelAvailable() {
    storeLabel.isUserInteractionEnabled = true
    storeLabel.textColor = .yg.primary
  }
  
  func setStoreLabelUnavailable() {
    storeLabel.isUserInteractionEnabled = false
    storeLabel.textColor = .yg.gray1
  }
  
  func configureUI() {
    modalPresentationStyle = .fullScreen
    view.backgroundColor = .yg.gray00Background
    setupUI()
    setNaviTitle()
    setNaviAppearance()
    setBackBarButton()
    setNaviRightBarButton()
  }
  
  func setNaviTitle() {
    navigationItem.titleView = BaseLabel(fontType: .semiBold_600(fontSize: 18)).set {
      $0.textAlignment = .center
      $0.text = "내 정보"
      $0.textColor = .yg.gray7
    }
  }
  
  func setNaviAppearance() {
    let baseAppearance = UINavigationBarAppearance()
    baseAppearance.backgroundColor = .white
    navigationItem.standardAppearance = baseAppearance
    navigationItem.scrollEdgeAppearance = baseAppearance
  }
  
  func setBackBarButton() {
    let backButton = UIButton(frame: .zero).set {
      $0.setImage(UIImage(named: "back"), for: .normal)
      $0.widthAnchor.constraint(equalToConstant: 55).isActive = true
      $0.heightAnchor.constraint(equalToConstant: 24).isActive = true
      $0.addTarget(self, action: #selector(didTapBackBarButton(_:)), for: .touchUpInside)
      let paragraphStyle = NSMutableParagraphStyle()
      paragraphStyle.alignment = .left
      let attributes = [
        .foregroundColor: UIColor.yg.gray7,
        .font: UIFont(pretendard: .medium_500(fontSize: 16)) ?? .systemFont(ofSize: 16),
        .paragraphStyle: paragraphStyle
      ] as [NSAttributedString.Key: Any]
      let attributedString = NSAttributedString(string: "MY", attributes: attributes)
      $0.setAttributedTitle(attributedString, for: .normal)
    }
    navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
  }
  
  func setNaviRightBarButton() {
    navigationItem.rightBarButtonItem = UIBarButtonItem(customView: storeLabel)
  }
  
  func setSubviewsDefaultUI() {
    setStoreLabelUnavailable()
    inputTextField.textState = .default
    inputNoticeLabel.text = ""
  }
  
  func handleWhenUserWantToLeaveThisPage(with hasUserEditedInfo: Bool ) {
    guard hasUserEditedInfo else {
      coordinator?.finish(withAnimated: true)
      return
    }
    coordinator?.showConfirmationAlertPage()
  }
  
  func handleSavableState(_ isStateSavable: Bool) {
    if isStateSavable {
      setStoreLabelAvailable()
      return
    }
    setStoreLabelUnavailable()
  }
}

// MARK: - Actions
extension MyInformationViewController {
  @objc func didTapBackBarButton(_ sender: Any) {
    input.tapBackButton.send()
  }
  
  @objc func didTapStoreLabel() {
    input.tapStoreButton.send()
  }
  
  @objc func didTapProfile() {
    coordinator?.showBottomSheetAlbum()
  }
}

// MARK: - LayoutSupport
extension MyInformationViewController: LayoutSupport {
  func addSubviews() {
    [profileImageView,
     nicknameLabel,
     inputNoticeLabel,
     inputTextField,
     connectedSNSLabel,
     connectedSNSStackView,
     logoutLabel,
     withdrawalLabel
    ].forEach {
      view.addSubview($0)
    }
  }
  
  func setConstraints() {
    NSLayoutConstraint.activate([
      profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
      
      nicknameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 32),
      nicknameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      
      inputNoticeLabel.centerYAnchor.constraint(equalTo: nicknameLabel.centerYAnchor),
      inputNoticeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      
      inputTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      inputTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      inputTextField.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor, constant: 4),
      inputTextField.heightAnchor.constraint(equalToConstant: 46),
      
      connectedSNSLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      connectedSNSLabel.topAnchor.constraint(equalTo: inputTextField.bottomAnchor, constant: 16),
      
      connectedSNSStackView.topAnchor.constraint(equalTo: connectedSNSLabel.bottomAnchor, constant: 17),
      connectedSNSStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 71.5),
      connectedSNSStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -71.5),
      
      logoutLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      logoutLabel.topAnchor.constraint(equalTo: connectedSNSStackView.bottomAnchor, constant: 25),
      
      withdrawalLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      withdrawalLabel.topAnchor.constraint(equalTo: logoutLabel.bottomAnchor, constant: 8)])
  }
}
