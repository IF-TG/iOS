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
  enum Constant {
    static let backgroundColor: UIColor = .white
    
    enum Notification {
      static let image = UIImage(named: "notification")
      static let size = CGSize(width: 24, height: 24)
      
      enum Spacing {
        static let top: CGFloat = 9.33
        static let bottom: CGFloat = 9.33
        static let leading: CGFloat = 10.33
        static let trailing: CGFloat = 10
      }
      
      static let topSpacaing: CGFloat = 9.33
      static let bottomSpacing: CGFloat = 9.33
      static let normalColor: UIColor = .yg.gray5
      static let highlightColor: UIColor = .yg.gray5.withAlphaComponent(0.5)
    }
    
    enum NotificationIcon {
      static let width: CGFloat = 5
      static let height: CGFloat = 5
      static let topSpacing: CGFloat = 9.33
      static let trailingSpacing: CGFloat = 5
      static let color: UIColor = UIColor(hex: "#FF2216")
    }
  }
  
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
    typealias Const = Constant.Notification
    typealias Spacing = Const.Spacing
    translatesAutoresizingMaskIntoConstraints = false
    
    let image = Const.image
    setImage(image?.setColor(Const.normalColor), for: .normal)
    setImage(image?.setColor(Const.highlightColor), for: .highlighted)
    contentEdgeInsets = UIEdgeInsets(
      top: Spacing.top,
      left: Spacing.leading,
      bottom: Spacing.bottom,
      right: Spacing.trailing)
    
  }
}

// MARK: - LayoutSupport
extension FeedNotificationBarItem: LayoutSupport {
  func addSubviews() {
    addSubview(notificationRedIcon)
  }
  
  func setConstraints() {
    typealias Const = Constant.NotificationIcon
    NSLayoutConstraint.activate([
      notificationRedIcon.topAnchor.constraint(
        equalTo: topAnchor,
        constant: Const.topSpacing),
      notificationRedIcon.trailingAnchor.constraint(
        equalTo: trailingAnchor,
        constant: -Const.trailingSpacing),
      notificationRedIcon.widthAnchor.constraint(
        equalToConstant: Const.width),
      notificationRedIcon.heightAnchor.constraint(
        equalToConstant: Const.height)])
  }
}
