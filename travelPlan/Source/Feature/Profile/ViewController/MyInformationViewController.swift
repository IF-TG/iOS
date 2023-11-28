//
//  MyInformationViewController.swift
//  travelPlan
//
//  Created by 양승현 on 11/27/23.
//

import UIKit

final class MyInformationViewController: UIViewController {
  // MARK: - Properties
  private let profileImageView = SettingMyProfileView()
  
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
    $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapStoreLabel)))
  }
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
  }
}

// MARK: - Private Helpers
private extension MyInformationViewController {
  func configureUI() {
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
}

// MARK: - Actions
extension MyInformationViewController {
  @objc func didTapBackBarButton(_ sender: Any) {
    navigationController?.popViewController(animated: true)
  }
  
  @objc func didTapStoreLabel() {
    // TODO: - 서버에 변경된 내용 보내서 변경해야합니다.
    
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
      connectedSNSStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      connectedSNSStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 71.5),
      connectedSNSStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -71.5),
      
      logoutLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      logoutLabel.topAnchor.constraint(equalTo: connectedSNSStackView.bottomAnchor, constant: 25),
      
      withdrawalLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      withdrawalLabel.topAnchor.constraint(equalTo: logoutLabel.bottomAnchor, constant: 8)])
  }
}
