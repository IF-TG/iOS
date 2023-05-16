//
//  FeedNotificationBarItem.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/16.
//

import UIKit

// 알림TODO: - 만약 알림이 왔다면 userNotificationState를 notChecked로 해야합니다.
/// 알림VC로 이동해서 로그인 한 사용자로부터 알림을 확인했을 경우 redIcon의 background 색을 white로 한 후 userNotificationState를 none으로 변경합니다.
enum UserNotificationState {
  case none
  case notChecked
}

final class FeedNotificationBarItem: UIButton {
  // MARK: - Properties
  var delegate: FeedNotificationBarItemDelegate?
  
  /// 사용자가 알림을 확인 했는지 여부를 체크하고 이에 따른 notificationIcon 상태를 rendering 합니다. 그 후 상태를 none으로 변경합니다.
  private var userNotificationState: UserNotificationState?

  private lazy var notificationRedIcon = UIView().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.layer.cornerRadius = Constant.NotificationIcon.width/2
    $0.backgroundColor = .white
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
  
  convenience init() {
    self.init(frame: .zero)
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
  func updateNotificationRedIcon(_ value: UserNotificationState) {
    userNotificationState = value
    updateRedIconColor()
  }
}

// MARK: - Private helpers
extension FeedNotificationBarItem {
  private func updateRedIconColor() {
    guard let userNotificationState = userNotificationState else { return }
    let redColor = Constant.NotificationIcon.color
    notificationRedIcon
      .backgroundColor = userNotificationState == .none ? .white : redColor
  }
  
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
