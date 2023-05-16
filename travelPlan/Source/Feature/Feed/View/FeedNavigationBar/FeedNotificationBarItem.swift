//
//  FeedNotificationBarItem.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/16.
//

import UIKit

final class FeedNotificationBarItem: UIButton {
  // MARK: - Properties
  
  var delegate: FeedNotificationBarItemDelegate?
  
  private var isCheckedNotification: Bool?
  
  private let notificationRedIcon = UIView().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.layer.cornerRadius = Constant.NotificationIcon.width/2
    $0.backgroundColor = .systemRed
  }
  
  // MARK: - Initialization
  private override init(frame: CGRect) {
    super.init(frame: .zero)
    configureUI()
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Action
extension FeedNotificationBarItem {
  @objc func didTapNotification() {
    delegate?.didTapNotification()
  }
}

// MARK: - Helpers
extension FeedNotificationBarItem {
  func updateIsCheckedNotification(_ value: Bool) {
    isCheckedNotification = value
    updateNotificationIconColor()
  }
}

// MARK: - Private helpers
extension FeedNotificationBarItem {
  private func updateNotificationIconColor() {
    guard let isCheckedNotification = isCheckedNotification else { return }
    let redColor = Constant.NotificationIcon.color
    notificationRedIcon
      .backgroundColor = isCheckedNotification ? .white : redColor
  }
}

extension FeedNotificationBarItem {
  func configureUI() {
    translatesAutoresizingMaskIntoConstraints = false
    let image = Constant.Notification.image
    setImage(
      image?.setColor(Constant.Notification.normalColor),
      for: .normal)
    setImage(
      image?.setColor(Constant.Notification.highlightColor),
      for: .highlighted)
    addTarget(self, action: #selector(didTapNotification), for: .touchUpInside)
    
    contentEdgeInsets = UIEdgeInsets(
      top: Constant.Notification.Inset.top,
      left: Constant.Notification.Inset.leading,
      bottom: Constant.Notification.Inset.bottom,
      right: Constant.Notification.Inset.trailing)
    
  }
}

// MARK: - LayoutSupport
extension FeedNotificationBarItem: LayoutSupport {
  func addSubviews() {
    addSubview(notificationRedIcon)
  }
  
  func setConstraints() {
    NSLayoutConstraint.activate([
      notificationRedIcon.topAnchor.constraint(
        equalTo: topAnchor,
        constant: Constant.NotificationIcon.topSpacing),
      notificationRedIcon.trailingAnchor.constraint(
        equalTo: trailingAnchor,
        constant: -Constant.NotificationIcon.trailingSpacing),
      notificationRedIcon.widthAnchor.constraint(
        equalToConstant: Constant.NotificationIcon.width),
      notificationRedIcon.heightAnchor.constraint(
        equalToConstant: Constant.NotificationIcon.height)])
  }
}
