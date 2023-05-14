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
    $0.text = " "
    $0.textAlignment = .left
    $0.font = Constant.Title.font
    $0.textColor = Constant.Title.textColor
    $0.numberOfLines = 1
    $0.isUserInteractionEnabled = true
    let touchGesture = UITapGestureRecognizer(target: self, action: #selector(didTapTitle))
    $0.addGestureRecognizer(touchGesture)
  }
  
  private lazy var profileImageView: UIImageView = UIImageView().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = .lightGray.withAlphaComponent(0.5)
    $0.clipsToBounds = true
    $0.isUserInteractionEnabled = true
    $0.contentMode = .scaleAspectFill
    let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapProfile))
    $0.isUserInteractionEnabled = true
    $0.addGestureRecognizer(gesture)
    $0.layer.cornerRadius = Constant.UserProfileImage.width/2
  }
  
  private let subInfoView = PostHeaderSubInfoView()
  
  private lazy var optionButton = UIButton().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.setImage(
      Constant.OptionView.selectedImage,
      for: .normal)
    $0.setImage(
      Constant.OptionView.unselectedImage,
      for: .highlighted)
    $0.addTarget(self, action: #selector(didTapOption), for: .touchUpInside)
  }
  
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

// MARK: - Public Helpers
extension PostHeaderView {
  func configure(with data: PostHeaderModel) {
    setTitle(with: data.title)
    setProfile(with: data.image)
    setSubInfo(with: data.subInfo)
  }
}

// MARK: - Helpers
extension PostHeaderView {
  private func setTitle(with text: String) {
    title.text = text
    title.sizeToFit()
  }
  
  private func setProfile(with image: UIImage?) {
    profileImageView.image = image
  }
  
  private func setSubInfo(
    with subInfoData: PostHeaderSubInfoModel
  ) {
    subInfoView.configure(with: subInfoData)
  }
}

// MARK: - Action
extension PostHeaderView {
  @objc func didTapTitle() {
    print("DEBUG: 탭탭!! title :)")
    UIView.touchAnimate(title, scale: 0.985)
  }
  
  @objc func didTapProfile() {
    print("DEBUG: Goto profile scene !!")
    UIView.touchAnimate(profileImageView)
  }
  
  @objc func didTapOption() {
    print("DEBUG: pop up option scene !!")
    UIView.touchAnimate(optionButton)
  }
}

// MARK: - LayoutSupport
extension PostHeaderView: LayoutSupport {
  func addSubviews() {
    _=[profileImageView, title, subInfoView, optionButton].map { addSubview($0) }
  }
  
  func setConstraints() {
    _=[profileImageViewConstraints, titleConstraints, subInfoViewConstraints, optionButtonConstraints].map {
      NSLayoutConstraint.activate($0)
    }
  }
}

// MARK: - LayoutSupport constraints
private extension PostHeaderView {
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
  
  var optionButtonConstraints: [NSLayoutConstraint] {
    [optionButton.trailingAnchor.constraint(
      equalTo: trailingAnchor,
      constant: -Constant.OptionView.Spacing.trailing),
     optionButton.topAnchor.constraint(
      equalTo: topAnchor,
      constant: Constant.OptionView.Spacing.top),
     optionButton.widthAnchor.constraint(
      equalToConstant: Constant.OptionView.size.width),
     optionButton.heightAnchor.constraint(
      equalToConstant: Constant.OptionView.size.height)]
  }
}
