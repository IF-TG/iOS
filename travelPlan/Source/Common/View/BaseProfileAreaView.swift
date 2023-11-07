//
//  BaseLeftRoundProfileAreaView.swift
//  travelPlan
//
//  Created by 양승현 on 2023/09/26.
//

import UIKit

protocol BaseProfileAreaViewDelegate: AnyObject {
  func baseLeftRoundProfileAreaView(
    _ view: BaseProfileAreaView,
    didSelectProfileImage image: UIImage?)
}

class BaseProfileAreaView: UIView {
  enum ProfileLayoutType {
    case centerY
    case top
  }
  
  enum ProfileInfoType {
    case small(ProfileLayoutType)
    case medium(ProfileLayoutType)
    
    var size: CGSize {
      switch self {
      case .small:
        return .init(width: 35, height: 35)
      case .medium:
        return .init(width: 40, height: 40)
      }
    }
    
    var radius: CGFloat {
      switch self {
      case .small:
        return size.width/2
      case .medium:
        return size.width/2
      }
    }
    
    var layoutType: ProfileLayoutType {
      switch self {
      case .small(let type):
        return type
      case .medium(let type):
        return type
      }
    }
  }
  
  // MARK: - Properties
  private var profileImageView: UIImageView!
  
  private var contentView: UIView
  
  private var contentViewSpacing: UIEdgeInsets = .zero
  
  weak var baseDelegate: BaseProfileAreaViewDelegate?
  
  private var profileLayoutInfo: ProfileInfoType
  
  // MARK: - Lifecycle
  init(
    frame: CGRect,
    contentView: UIView,
    profileLayoutInfo: ProfileInfoType
  ) {
    self.profileLayoutInfo = profileLayoutInfo
    self.contentView = contentView
    super.init(frame: frame)
    configureUI()
  }
  
  init(
    frame: CGRect,
    contentView: UIView,
    contentViewSpacing: UIEdgeInsets,
    profileLayoutInfo: ProfileInfoType
  ) {
    self.profileLayoutInfo = profileLayoutInfo
    self.contentView = contentView
    self.contentViewSpacing = contentViewSpacing
    super.init(frame: frame)
    configureUI()
  }
  
  required init?(coder: NSCoder) {
    profileLayoutInfo = .small(.centerY)
    contentView = .init(frame: .zero)
    super.init(coder: coder)
    configureUI()
  }
  
  // MARK: - Helper
  func configure(with imagePath: String?) {
    guard let imagePath = imagePath else {
      profileImageView.image = nil
      return
    }
    profileImageView.image = UIImage(named: imagePath)
  }
  
  // MARK: - Private helper
  private func configureUI() {
    translatesAutoresizingMaskIntoConstraints = false
    makeProfileImageView()
    configureLayout()
    setSubviewsPriority()
  }
  
  private func makeProfileImageView() {
    profileImageView = UIImageView(frame: .zero).set {
      $0.translatesAutoresizingMaskIntoConstraints = false
      $0.backgroundColor = .lightGray.withAlphaComponent(0.5)
      $0.clipsToBounds = true
      $0.isUserInteractionEnabled = true
      $0.contentMode = .scaleAspectFill
      let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapProfile))
      $0.addGestureRecognizer(gesture)
      $0.layer.cornerRadius = profileLayoutInfo.radius
    }
  }
  
  private func setSubviewsPriority() {
    profileImageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    contentView.setContentHuggingPriority(.defaultLow, for: .horizontal)
  }
  
  private func configureLayout() {
    _=[
      profileImageView,
      contentView
    ].map {
      addSubview($0)
    }
    _=[
      profileImageViewConstraints,
      contentViewConstraints
    ].map {
      NSLayoutConstraint.activate($0)
    }
  }
  
  private var profileImageViewConstraints: [NSLayoutConstraint] {
    let constraints = [
      profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
      profileImageView.widthAnchor.constraint(equalToConstant: profileLayoutInfo.size.width),
      profileImageView.heightAnchor.constraint(equalToConstant: profileLayoutInfo.size.height)]
    guard profileLayoutInfo.layoutType == .top else {
      return constraints + [profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor)]
    }
    return constraints + [profileImageView.topAnchor.constraint(equalTo: topAnchor)]
  }
  
  private var contentViewConstraints: [NSLayoutConstraint] {
    let spacing = contentViewSpacing
    let contentViewBottomConstraint = contentView.bottomAnchor.constraint(
      equalTo: bottomAnchor,
      constant: -spacing.bottom)
    contentViewBottomConstraint.priority = .defaultHigh
    return [
      contentView.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: -spacing.left),
      contentView.topAnchor.constraint(equalTo: topAnchor, constant: spacing.top),
      contentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -spacing.right),
      contentViewBottomConstraint
    ]
  }
  
  // MARK: - Action
  @objc func didTapProfile() {
    print("DEBUG: Goto profile scene !!")
    baseDelegate?.baseLeftRoundProfileAreaView(self, didSelectProfileImage: profileImageView.image)
  }
}
