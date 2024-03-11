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
  
  private let input = MyInformationViewModel.Input()
  
  private let viewModel: any MyInformationViewModelable
  
  private var subscriptions = Set<AnyCancellable>()
  
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
    bind()
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
  typealias ErrorType = MainError
  typealias State = MyInformationViewModel.State
  
  func bind() {
    bindInputTextField()
    bindInputTextFieldTextState()
    let output = viewModel.transform(input)
    output
      .receive(on: DispatchQueue.main)
      .sink { [weak self] completion in
        switch completion {
        case .finished:
          return
        case .failure(let error):
          self?.handleError(error)
        }
      } receiveValue: { [weak self] state in
        self?.render(state)
      }.store(in: &subscriptions)
  }
  
  func render(_ state: MyInformationViewModel.State) {
    switch state {
    case .none:
      break
    case .duplicatedNickname:
      inputTextField.textState = .duplicated
      stopIndicator()
    case .availableNickname:
      inputTextField.textState = .available
      stopIndicator()
    case .correctionSaved:
      stopIndicator()
      // TODO: - 저장 성공 알림창 응답.+ (닉네임, 이미지 bool) 받고 칸 갱신
      setSubviewsDefaultUI()
    case .correctionNotSaved:
      // TODO: - 저장 실패시 알림창 응답.
      stopIndicator()
    case .networkProcessing:
      startIndicator()
    }
  }
  
  func handleError(_ error: ErrorType) {
    // TODO: - 추후 알림창에 표현하기
    switch error {
    case .general(let string):
      print(string.description)
    case .networkError(let error):
      print(error.localizedDescription)
    case .referenceError(let error):
      print(error.localizedDescription)
    }
  }
}

// MARK: - Private Helpers
private extension MyInformationViewController {
  func bindInputTextField() {
    inputTextField
      .changed
      .debounce(for: 0.2, scheduler: RunLoop.main)
      .sink { [weak self] in
        let isNicknameAvailable = (3...15).contains($0.count)
        let isNicknameWithinMinimumRange = (1...2).contains($0.count)
        let isInputTextfieldEmpty = $0.count == 0 || $0.isEmpty
        if isNicknameAvailable {
          self?.input.isNicknameDuplicated.send($0)
        } else if isInputTextfieldEmpty {
          self?.inputTextField.textState = .initial
        } else if isNicknameWithinMinimumRange {
          self?.inputTextField.textState = .underflow
        } else {
          /// 닉네임 글자 넘음
          self?.inputTextField.textState = .overflow
        }
        if self?.inputTextField.textState != .available {
          self?.storeLabel.isUserInteractionEnabled = false
          self?.storeLabel.textColor = .yg.gray1
        }
        self?.inputNoticeLabel.text = self?.inputTextField.textState.quotation
      }.store(in: &subscriptions)
  }
  
  func bindInputTextFieldTextState() {
    inputTextField.$textState
      .receive(on: DispatchQueue.main)
      .sink { [weak self] state in
        if state == .duplicated {
          self?.inputNoticeLabel.text = self?.inputTextField.textState.quotation
          self?.inputNoticeLabel.textColor = .yg.red2
          self?.storeLabel.isUserInteractionEnabled = false
          self?.storeLabel.textColor = .yg.gray1
        }
        if state == .available {
          self?.inputNoticeLabel.textColor = .yg.primary
          self?.inputNoticeLabel.text = self?.inputTextField.textState.quotation
          self?.storeLabel.isUserInteractionEnabled = true
          self?.storeLabel.textColor = .yg.primary
        }
        if state == .underflow {
          self?.inputNoticeLabel.textColor = .yg.red2
        }
        if state == .overflow {
          self?.inputNoticeLabel.textColor = .yg.red2
        }
      }.store(in: &subscriptions)
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
    storeLabel.textColor = .yg.gray1
    storeLabel.isUserInteractionEnabled = false
    inputTextField.textState = .normal
    inputNoticeLabel.text = ""
  }
}

// MARK: - Actions
extension MyInformationViewController {
  @objc func didTapBackBarButton(_ sender: Any) {
    navigationController?.popViewController(animated: true)
  }
  
  @objc func didTapStoreLabel() {
    input.tapStoreButton.send()
  }
  
  @objc func didTapBottomSheetComponent(_ gesture: UITapGestureRecognizer) {
    guard let selectedLabel = gesture.view as? UILabel, let text = selectedLabel.text else {
      return
    }
    dismiss(animated: false)
    let picker = UIImagePickerController()
    picker.allowsEditing = true
    picker.delegate = self
    switch text {
    case "사진 찍기":
      picker.sourceType = .camera
      picker.cameraDevice = .rear
      picker.cameraCaptureMode = .photo
    case "앨범에서 선택":
      picker.sourceType = .photoLibrary
    default:
      return
    }
    present(picker, animated: true)
  }
  
  @objc func didTapProfile() {
    let dividers: [UIView] = (0...1).map { _ in
      return UIView(frame: .zero).set {
        $0.heightAnchor.constraint(equalToConstant: 0.7).isActive = true
        $0.backgroundColor = .yg.gray1
      }
    }
    let titles = ["사진 찍기", "앨범에서 선택"]
    let labels = (0...1).map { index in
      return BasePaddingLabel(
        padding: .init(top: 15, left: 35, bottom: 15, right: 35),
        fontType: .semiBold_600(fontSize: 16),
        lineHeight: 25
      ).set {
        $0.isUserInteractionEnabled = true
        $0.text = titles[index]
        $0.textColor = .yg.gray5
        $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapBottomSheetComponent)))
      }
    }
    let stackView = UIStackView(arrangedSubviews: [labels[0], dividers[0], labels[1], dividers[1]]).set {
      $0.translatesAutoresizingMaskIntoConstraints = false
      $0.isUserInteractionEnabled = true
      $0.axis = .vertical
      $0.spacing = 0
      $0.distribution = .fill
      $0.backgroundColor = .white
    }
    let bottomSheet = BaseBottomSheetViewController(contentView: stackView, mode: .couldBeFull, radius: 13)
    presentBottomSheet(bottomSheet)
  }
}

// MARK: - UIImagePickerControllerDelegate
extension MyInformationViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
  func imagePickerController(
    _ picker: UIImagePickerController,
    didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
  ) {
    if let image = info[.editedImage] as? UIImage {
      profileImageView.setImage(image)
      input.selectProfile.send(image.base64)
    }
    picker.dismiss(animated: true, completion: nil)
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true, completion: nil)
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
