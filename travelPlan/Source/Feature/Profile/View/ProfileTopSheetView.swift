//
//  ProfileTopSheetView.swift
//  travelPlan
//
//  Created by 양승현 on 11/2/23.
//

import UIKit

final class ProfileTopSheetView: UIView {
  enum Constant {
    static let radius: CGFloat = 30
    enum NameLabel {
      enum Spacing {
        static let top: CGFloat = 58.5 + 47
        static let leading: CGFloat = 20
      }
    }
    enum ProfileImageView {
      static let size: CGSize = .init(width: 80, height: 80)
      enum Spacing {
        static let leading: CGFloat = 10
        static let trailing: CGFloat = 30
      }
    }
  }
  
  // MARK: - Properties
  private let nameLabel = UILabel().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.text = "김석현님,\n어디로 떠나시게요?🎒"
    $0.numberOfLines = 2
    $0.font = UIFont.systemFont(ofSize: 24)
    $0.textColor = UIColor(red: 0.984, green: 0.984, blue: 0.984, alpha: 1)
  }
  
  private let profileImageView = UIImageView(frame: .zero).set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.layer.cornerRadius = Constant.ProfileImageView.size.width/2
    $0.contentMode = .scaleAspectFill
    $0.clipsToBounds = true
  }
  
  private var isShadowSet = false
  
  override var bounds: CGRect {
    didSet {
      if !isShadowSet {
        isShadowSet.toggle()
        setShadow()
      }
    }
  }
  
  // MARK: - Lifecycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureUI()
  }
  
  init() {
    super.init(frame: .zero)
    configureUI()
    translatesAutoresizingMaskIntoConstraints = false
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    configureUI()
  }
}

// MARK: - Helpers
extension ProfileTopSheetView {
  func configure(with imagePath: String) {
    profileImageView.image = UIImage(named: imagePath)
  }
  
  func prepareForAnimation() {
    nameLabel.alpha = 0
    nameLabel.transform = .init(translationX: 0, y: +nameLabel.bounds.height/2)
    profileImageView.alpha = 0
    profileImageView.transform = .init(translationX: 0, y: +nameLabel.bounds.height/2)
  }
  
  func showAnimation() {
    UIView.animate(
      withDuration: 0.25,
      delay: 0,
      options: .curveEaseInOut,
      animations: {
        self.nameLabel.alpha = 1
        self.profileImageView.alpha = 1
        self.nameLabel.transform = .identity
        self.profileImageView.transform = .identity
      })
  }
}

// MARK: - Private Helpers
private extension ProfileTopSheetView {
  func configureUI() {
    layer.cornerRadius = Constant.radius
    layer.setCornerMask(.leftBottom, .rightBottom)
    layer.backgroundColor = UIColor.yg.primary.cgColor
    setupUI()
  }
  
  func setShadow() {
    let bezier = UIBezierPath(rect: bounds)
    layer.shadowPath = bezier.cgPath
    layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15).cgColor
    layer.shadowOpacity = 1
    layer.shadowRadius = 10
    layer.shadowOffset = CGSize(width: 0, height: 2)
  }
}

// MARK: - LayoutSupport
extension ProfileTopSheetView: LayoutSupport {
  func addSubviews() {
    _=[
      nameLabel,
      profileImageView
    ].map {
      addSubview($0)
    }
  }
  
  func setConstraints() {
    _=[
      nameLabelConstraints,
      profileImageViewConstraints
    ].map {
      NSLayoutConstraint.activate($0)
    }
  }
}

// MARK: - LayoutSupport Constraints
private extension ProfileTopSheetView {
  var nameLabelConstraints: [NSLayoutConstraint] {
    typealias Const = Constant.NameLabel
    typealias Spacing = Const.Spacing
    return [
      nameLabel.leadingAnchor.constraint(
        equalTo: leadingAnchor,
        constant: Spacing.leading),
      nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: Spacing.top)]
  }
  
  var profileImageViewConstraints: [NSLayoutConstraint] {
    typealias Const = Constant.ProfileImageView
    typealias Spacing = Const.Spacing
    return [
      profileImageView.leadingAnchor.constraint(
        equalTo: nameLabel.trailingAnchor,
        constant: Spacing.leading),
      profileImageView.trailingAnchor.constraint(
        equalTo: trailingAnchor,
        constant: -Spacing.trailing),
      profileImageView.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
      profileImageView.widthAnchor.constraint(equalToConstant: Const.size.width),
      profileImageView.heightAnchor.constraint(equalToConstant: Const.size.height)]
  }
}
