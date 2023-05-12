//
//  PostHeaderView.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/12.
//

import UIKit

final class PostHeaderView: UIView {
  // MARK: - Properteis
  private lazy var title = UILabel().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.text = "제목 제목"
    $0.textAlignment = .left
    $0.font = Constant.Title.font
    $0.textColor = Constant.Title.textColor
    $0.numberOfLines = 1
    $0.sizeToFit()
    $0.isUserInteractionEnabled = true
    let touchGesture = UITapGestureRecognizer(target: self, action: #selector(didTapTitle))
    $0.addGestureRecognizer(touchGesture)
  }
  private lazy var profileImageView: UIImageView = UIImageView().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = .lightGray.withAlphaComponent(0.5)
    $0.clipsToBounds = true
    $0.isUserInteractionEnabled = true
    $0.contentMode = .scaleAspectFit
    let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapProfile))
    $0.isUserInteractionEnabled = true
    $0.addGestureRecognizer(gesture)
    $0.layer.cornerRadius = Constant.UserProfileImage.width/2
    $0.sizeToFit()
  }
  private let subInfoView = PostHeaderSubInfoView()
  
  // MARK: - Initialization
  private override init(frame: CGRect) {
    super.init(frame: .zero)
    translatesAutoresizingMaskIntoConstraints = false
    backgroundColor = .yg.gray00Background
    setupUI()
  }
  
  convenience init() {
    self.init(frame: .zero)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Helpers
extension PostHeaderView {
  func setupData(_ data: [String]) {
    // 헤더에 관한 데이터 받는다.
    // 헤더에 필요한 데이터는 프로필 이미지, 이름, 제목, 여행 기간, 여행 년월일기간
  }
}

// MARK: - Action Event
extension PostHeaderView {
  @objc func didTapTitle() {
    print("DEBUG: 탭탭!! title :)")
    UIView.touchAnimate(title, scale: 0.985)
  }
  
  @objc func didTapProfile() {
    print("DEBUG: Goto profile scene !!")
    UIView.touchAnimate(profileImageView)
  }
}

// MARK: - LayoutSupport
extension PostHeaderView: LayoutSupport {
  func addSubviews() {
    _=[profileImageView, title, subInfoView].map { addSubview($0) }
  }
  
  func setConstraints() {
    _=[profileImageViewConstraints, titleConstraints, subInfoViewConstraints].map {
      NSLayoutConstraint.activate($0)
    }
  }
}

fileprivate extension PostHeaderView {
  var profileImageViewConstraints: [NSLayoutConstraint] {
    [profileImageView.topAnchor.constraint(
      equalTo: topAnchor,
      constant: Constant.UserProfileImage.Spacing.top),
     profileImageView.leadingAnchor.constraint(
      equalTo: leadingAnchor,
      constant: Constant.UserProfileImage.Spacing.leading),
     profileImageView.bottomAnchor.constraint(
      equalTo: bottomAnchor,
      constant: -Constant.UserProfileImage.Spacing.bottom),
     profileImageView.widthAnchor.constraint(
      equalToConstant: Constant.UserProfileImage.width),
     profileImageView.heightAnchor.constraint(
      equalToConstant: Constant.UserProfileImage.height)]
  }
  
  var titleConstraints: [NSLayoutConstraint] {
    [title.leadingAnchor.constraint(
      equalTo: profileImageView.trailingAnchor,
      constant: Constant.Title.Spacing.leading),
     title.topAnchor.constraint(
      equalTo: topAnchor,
      constant: Constant.Title.Spacing.top),
     title.trailingAnchor.constraint(
      equalTo: trailingAnchor,
      constant: -Constant.Title.Spacing.trailing)
    ]
  }
  
  var subInfoViewConstraints: [NSLayoutConstraint] {
    [subInfoView.leadingAnchor.constraint(
      equalTo: profileImageView.trailingAnchor,
      constant: Constant.SubInfoView.Spacing.leading),
     subInfoView.topAnchor.constraint(
      equalTo: title.bottomAnchor,
      constant: Constant.SubInfoView.Spacing.top),
     subInfoView.bottomAnchor.constraint(
      equalTo: bottomAnchor,
      constant: -Constant.SubInfoView.Spacing.bottom),
     subInfoView.trailingAnchor.constraint(
      equalTo: trailingAnchor,
      constant: -Constant.SubInfoView.Spacing.trailing)]
  }
}
