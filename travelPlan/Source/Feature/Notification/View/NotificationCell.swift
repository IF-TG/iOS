//
//  NotificationCell.swift
//  travelPlan
//
//  Created by 양승현 on 11/1/23.
//

import UIKit

/// 댓글, 대댓글의 경우
final class NotificationCell: BaseNotificationCell {
  let notCheckedStateBackgroundColor = UIColor.yg.primary.withAlphaComponent(0.07)
  static let id = String(describing: NotificationCell.self)
  
  // MARK: - Properties
  private let title = BaseLabel(fontType: .regular_400(fontSize: 14), lineHeight: 20).set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.numberOfLines = 2
    $0.textColor = .yg.gray5
  }
  
  private let details = BaseLabel(fontType: .regular_400(fontSize: 13), lineHeight: 20).set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.numberOfLines = 3
    $0.textColor = .yg.gray4
  }
  
  private let duration = BaseLabel(fontType: .medium_500(fontSize: 11), lineHeight: 20).set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.numberOfLines = 1
    $0.textColor = .yg.gray3
  }
  
  private let hiddenDetailsConstraint: NSLayoutConstraint
  
  private let showedDetailsConstraint: NSLayoutConstraint
  
  // MARK: - Lifecycles
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    
    let containerView = UIView(frame: .zero)
    _=[
      title,
      details,
      duration
    ].map {
      containerView.addSubview($0)
    }
    
    hiddenDetailsConstraint = duration.topAnchor.constraint(equalTo: title.bottomAnchor)
    
    showedDetailsConstraint = duration.topAnchor.constraint(equalTo: details.bottomAnchor)
    
    let durationBottomConstraint = duration.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
    durationBottomConstraint.priority = .defaultHigh
    NSLayoutConstraint.activate([
      title.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
      title.topAnchor.constraint(equalTo: containerView.topAnchor),
      title.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
      
      details.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
      details.topAnchor.constraint(equalTo: title.bottomAnchor),
      details.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
      
      duration.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
      showedDetailsConstraint,
      duration.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
      durationBottomConstraint])
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setBaseContentView(containerView)
  }
  
  required init?(coder: NSCoder) {
    nil
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    configure(with: nil)
  }
}

// MARK: - Helpers
extension NotificationCell {
  func configure(with data: NotificationInfo?) {
    super.baseConfigure(with: data?.type.path)
    setTitle(userName: data?.userName, notificationType: data?.type)
    setDetails(data?.details, notificationType: data?.type)
    setDuration(data?.duration)
    contentView.backgroundColor = (data?.isChecked ?? false) ? .white : notCheckedStateBackgroundColor
  }
}

// MARK: - Private Helpers
private extension NotificationCell {
  func setTitle(userName: String?, notificationType: NotificationType?) {
    guard let userName, let notificationType else {
      title.attributedText = nil
      return
    }
    let text = userName + notificationType.suffixWords
    title.text = text
    let userNameHighlightInfo = HighlightFontInfo(
      fontType: .semiBold_600(fontSize: 14),
      text: userName)
    let postTitleHighlightInfo = HighlightFontInfo(
      fontType: .semiBold_600(fontSize: 14),
      text: notificationType.postTitle,
      startIndex: userName.count+3)
    title.setHighlights(with: userNameHighlightInfo, postTitleHighlightInfo)
    
  }
  
  func setDetails(_ text: String?, notificationType: NotificationType?) {
    if isHeartNotification(with: notificationType) { return }
    guard let text else {
      details.attributedText = nil
      return
    }
    details.text = text
  }
  
  func isHeartNotification(with type: NotificationType?) -> Bool {
    guard let type, type.isEqual(rhs: .heart(postTitle: "")) else {
      updateVisibleDetails(false)
      return false
    }
    updateVisibleDetails(true)
    return true
  }
  
  func updateVisibleDetails(_ isHidden: Bool) {
    details.isHidden = isHidden
    hiddenDetailsConstraint.isActive = isHidden
    showedDetailsConstraint.isActive = !isHidden
  }
  
  func setDuration(_ text: String?) {
    guard let text else {
      duration.attributedText = nil
      return
    }
    duration.text = text
  }
}
