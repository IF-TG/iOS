//
//  FeedNavigationBar.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/10.
//

import UIKit
import Combine

final class FeedNavigationBar: UIView {
  // MARK: - Properties
  var delegate: FeedNavigationBarDelegate?
  
  private var subscriptions = Set<AnyCancellable>()
  
  private let appTitle: UILabel = UILabel().set {
    let text = Constant.Title.text
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.textColor = Constant.Title.textColor
    $0.font = UIFont(
      name: Constant.Title.fontName,
      size: Constant.Title.fontSize)
    $0.numberOfLines = 0
    $0.textAlignment = .center
    var paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineHeightMultiple = 1.02
    $0.attributedText = NSMutableAttributedString(
      string: text,
      attributes: [.kern: -0.41, .paragraphStyle: paragraphStyle])
  }
  
  private lazy var postSearchButton = UIButton().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    let image = Constant.postSearch.image
    $0.setImage(
      image?.setColor(Constant.postSearch.normalColor),
      for: .normal)
    $0.setImage(
      image?.setColor(Constant.postSearch.highlightColor),
      for: .highlighted)
  }
  
  private lazy var notificationButton = UIButton().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    let image = Constant.Notification.image
    $0.setImage(
      image?.setColor(Constant.Notification.normalColor),
      for: .normal)
    $0.setImage(
      image?.setColor(Constant.Notification.highlightColor),
      for: .highlighted)
  }
  
  /// 사용자가 알림을 확인 했는지 여부를 체크하고 이에 따른 notificationIcon 상태를 rendering 합니다.
  /// FeedViewController를 생성하기 이전에 최초로 사용자가 알림을 확인했는지 여부를 파악해야 합니다.
  /// 추후 서버 통신할 때, 로그인 유저에게 알림을 보낸 여부 또한 확인해야 합니다.
  /// 이 상태를 저장해 둔 후 FeedViewController가 보여질 때마다 실시간으로 이 상태를 갱신해야 합니다.
  private var isCheckedNotification: Bool = {
    /// userDefaults나 전역 변수를 통해 사용자에게 알림이 있거나 확인하지 않았던 알림이 있을 경우를 확인합니다.
    false
  }()
  
  /// notificationButton과 Icon, searchButton의 경우 isCheckedNotification의 확인이 된 후에야 레이아웃 지정이 가능합니다.
  private lazy var notificationRedIcon = UIView().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.layer.cornerRadius = Constant.NotificationIcon.width/2
    let redColor = Constant.NotificationIcon.color
    $0.backgroundColor = isCheckedNotification ? Constant
      .backgroundColor : redColor
  }
  
  // MARK: - Initialization
  private override init(frame: CGRect) {
    super.init(frame: frame)
    translatesAutoresizingMaskIntoConstraints = false
    setupUI()
    backgroundColor = Constant.backgroundColor
    bind()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  convenience init() {
    self.init(frame: .zero)
  }
  
  deinit {
    _=subscriptions.map { $0.cancel() }
  }
}

// MARK: - Helper
extension FeedNavigationBar {
  
  private func bind() {
    postSearchButton.tap.sink {
      self.delegate?.didTapPostSearch()
    }.store(in: &subscriptions)
    notificationButton.tap.sink {
      self.delegate?.didTapNotification()
    }.store(in: &subscriptions)
  }
  
  func layoutFrom(_ navigationBar: UINavigationBar) {
    let navi = navigationBar
    navi.addSubview(self)
    NSLayoutConstraint.activate([
      topAnchor.constraint(equalTo: navi.topAnchor),
      leadingAnchor.constraint(equalTo: navi.leadingAnchor),
      trailingAnchor.constraint(equalTo: navi.trailingAnchor),
      bottomAnchor.constraint(equalTo: navi.bottomAnchor)])
  }
  
  func updateIsCheckedNotification() {
    /// 이 곳에서 앱 내부에서 기록하고 있던( 앱 종료 후에도 정보 갖고 있어야 하기 때문입니다. )
    /// 객체의 상태도 업데이트 하고 isCheckedNotification 또한 업데이트 합니다.
    isCheckedNotification = isCheckedNotification ? false : true
    updateFeedNavigationBarNotificationCheckState()
    updateNotificationIconColor()
  }
  
  private func updateFeedNavigationBarNotificationCheckState() {
    /// userDefaults에 저장된 feed navigation bar notification check state를 갱신합니다.
  }
  
  private func updateNotificationIconColor() {
    let redColor = Constant.NotificationIcon.color
    notificationRedIcon
      .backgroundColor = isCheckedNotification ? .white : redColor
  }
}

// MARK: - LayoutSupport
extension FeedNavigationBar: LayoutSupport {
  func addSubviews() {
    _=[appTitle, postSearchButton, notificationButton, notificationRedIcon]
      .map { addSubview($0) }
  }
  
  func setConstraints() {
    _=[appTitleConstraint,
       notificationButtonConstraint,
       postSearchButtonConstraint,
       notificationRedIconConstraint]
      .map { NSLayoutConstraint.activate($0) }
  }
}

fileprivate extension FeedNavigationBar {
  var appTitleConstraint: [NSLayoutConstraint] {
    [appTitle.leadingAnchor.constraint(
      equalTo: leadingAnchor,
      constant: Constant.Title.leadingSpacing),
     appTitle.topAnchor.constraint(
      equalTo: topAnchor,
      constant: Constant.Title.topSpacing),
     appTitle.bottomAnchor.constraint(
      equalTo: bottomAnchor,
      constant: -Constant.Title.bottomSpacing)]
  }
  
  var postSearchButtonConstraint: [NSLayoutConstraint] {
    [postSearchButton.topAnchor.constraint(
      equalTo: topAnchor,
      constant: Constant.postSearch.topSpacing),
     postSearchButton.trailingAnchor.constraint(
      equalTo: notificationButton.leadingAnchor,
      constant: -Constant.postSearch.trailingSpacing),
     postSearchButton.bottomAnchor.constraint(
      equalTo: bottomAnchor,
      constant: -Constant.postSearch.bottomSpacing)]
  }
  
  var notificationButtonConstraint: [NSLayoutConstraint] {
    [notificationButton.topAnchor.constraint(
      equalTo: topAnchor,
      constant: Constant.Notification.topSpacaing),
     notificationButton.trailingAnchor.constraint(
      equalTo: notificationRedIcon.leadingAnchor),
     notificationButton.bottomAnchor.constraint(
      equalTo: bottomAnchor,
      constant: -Constant.Notification.bottomSpacing)]
  }
  
  var notificationRedIconConstraint: [NSLayoutConstraint] {
    [notificationRedIcon.topAnchor.constraint(
      equalTo: topAnchor,
      constant: Constant.NotificationIcon.topSpacing),
     notificationRedIcon.trailingAnchor.constraint(
      equalTo: trailingAnchor,
      constant: -Constant.NotificationIcon.trailingSpacing),
     notificationRedIcon.widthAnchor.constraint(
      equalToConstant: Constant.NotificationIcon.width),
     notificationRedIcon.heightAnchor.constraint(
      equalToConstant: Constant.NotificationIcon.height)]
  }
}
