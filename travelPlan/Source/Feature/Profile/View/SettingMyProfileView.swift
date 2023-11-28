//
//  SettingMyProfileView.swift
//  travelPlan
//
//  Created by 양승현 on 11/27/23.
//

import UIKit

final class SettingMyProfileView: UIView {
  // MARK: - Properties
  private static let size: CGFloat = 80
  
  // TODO: - 파일메니저에 사용자 프로필 등록 여부 조회 후 연산 프로퍼티 적용
  private var isDefaultState = true
  
  private lazy var profileImageView = UIImageView(frame: .zero).set { [weak self] in
    $0.contentMode = .scaleAspectFill
    $0.clipsToBounds = true
    $0.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    $0.layer.cornerRadius = SettingMyProfileView.size/2
    // TODO: - 파일매니저를 통해 사용자 프로필이 등록되어있는지 찾기. 없다면 기본 프로필아이콘 적용
    $0.image = UIImage(named: "defaultProfileIcon")
    self?.isDefaultState = true
  }
  
  private lazy var photoIcon = UIImageView(frame: .zero).set {
    $0.contentMode = .scaleToFill
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.image = UIImage(named: "cameraIcon")
  }
  
  // MARK: - Lifecycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
    backgroundColor = .systemPink
  }
  
  convenience init() {
    self.init(frame: .zero)
    translatesAutoresizingMaskIntoConstraints = false
  }
  
  required init?(coder: NSCoder) { nil }
  
  override var intrinsicContentSize: CGSize {
    return .init(width: 80, height: 80)
  }
}

// MARK: - Helpers
extension SettingMyProfileView {
  func setImage(_ image: UIImage) {
    profileImageView.image = image
    if isDefaultState == true {
      isDefaultState.toggle()
      photoIcon.isHidden = true
    }
  }
}

// MARK: - LayoutSupport
extension SettingMyProfileView: LayoutSupport {
  func addSubviews() {
    addSubview(profileImageView)
    if isDefaultState {
      addSubview(photoIcon)
    }
  }
  
  func setConstraints() {
    if isDefaultState {
      NSLayoutConstraint.activate([
        photoIcon.bottomAnchor.constraint(equalTo: bottomAnchor),
        photoIcon.trailingAnchor.constraint(equalTo: trailingAnchor),
        photoIcon.widthAnchor.constraint(equalToConstant: 32),
        photoIcon.heightAnchor.constraint(equalToConstant: 32)])
    }
  }
}