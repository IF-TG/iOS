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
  private var isCheckedNotification: Bool
  
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
    //임시 값
    isCheckedNotification = false
    super.init(frame: frame)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  /// 계산된 뷰를
  convenience init(isCheckedNotification: Bool) {
    self.init(frame: .zero)
    self.isCheckedNotification = isCheckedNotification
    translatesAutoresizingMaskIntoConstraints = false
    setupUI()
    backgroundColor = Constant.backgroundColor
    bind()
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
  
  func updateIsCheckedNotification(_ value: Bool) {
    isCheckedNotification = value
    updateNotificationIconColor()
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
