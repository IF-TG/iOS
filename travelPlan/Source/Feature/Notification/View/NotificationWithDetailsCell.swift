//
//  NotificationWithDetailsCell.swift
//  travelPlan
//
//  Created by 양승현 on 11/1/23.
//

import UIKit

final class NotificationWithDetailsCell: BaseNotificationCell {
  enum Constant {
    enum Title {
      static let boldFont = UIFont(pretendard: .semiBold, size: 14)!
      static let normalFont = UIFont(pretendard: .regular, size: 14)!
      static let lineHeight: CGFloat = 20
      static let textColor: UIColor = .yg.gray5
    }
    enum Details {
      static let font = UIFont(pretendard: .regular, size: 13)!
      static let lineHeight: CGFloat = 20
      static let textColor: UIColor = .yg.gray4
    }
    enum Duration {
      static let font = UIFont(pretendard: .regular, size: 11)!
      static let lineHeight: CGFloat = 20
      static let textColor: UIColor = .yg.gray3
    }
  }
  
  // MARK: - Properties
  private let title = UILabel().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.numberOfLines = 2
  }
  
  private let details = UILabel().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.numberOfLines = 3
  }
  
  private let duration = UILabel().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.numberOfLines = 1
  }
  
  // MARK: - Lifecycles
  init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    let containerView = UIView(frame: .zero)
    _=[
      title,
      details,
      duration
    ].map {
      containerView.addSubview($0)
    }
    
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
      duration.topAnchor.constraint(equalTo: details.bottomAnchor),
      duration.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
      durationBottomConstraint])
    
    super.init(baseContentView: containerView, style: style, reuseIdentifier: reuseIdentifier)
  }
  
  required init?(coder: NSCoder) {
    nil
  }
}

// MARK: - Helpers
extension NotificationWithDetailsCell {
  func configure(with data: NotificationInfo?) {
    setTitle(userName: data?.userName, notificationType: data?.type)
  }
}

// MARK: - Private Helpers
private extension NotificationWithDetailsCell {
  // TODO: - pretendard 전용 레이블 생성하기!!
  func setTitle(userName: String?, notificationType: NotificationType?) {
    guard let userName, let notificationType else {
      title.attributedText = nil
      return
    }
    typealias Const = Constant.Title
    let text = userName + notificationType.suffixWords
    let style = NSMutableParagraphStyle().set {
      $0.maximumLineHeight = Const.lineHeight
      $0.minimumLineHeight = Const.lineHeight
    }
    let defaultAttributes = [
      .foregroundColor: Const.textColor,
      .font: Const.normalFont,
      .paragraphStyle: style
    ] as [NSAttributedString.Key: Any]
    
    let attrStr = NSMutableAttributedString(string: text)
    attrStr.addAttributes(defaultAttributes, range: NSRange(location: 0, length: text.count))
    
    let boldAttributes = [.font: Const.boldFont] as [NSAttributedString.Key: Any]
    
    attrStr.addAttributes(boldAttributes, range: NSRange(location: 0, length: userName.count))
    attrStr.addAttributes(
      boldAttributes,
      range: NSRange(location: userName.count+3, length: notificationType.postTitle.count))
  }
  
  func setDetails(_ text: String?) {
    guard let text else {
      details.attributedText = nil
      return
    }
    typealias Const = Constant.Details
    let style = NSMutableParagraphStyle().set {
      $0.minimumLineHeight = Const.lineHeight
      $0.maximumLineHeight = Const.lineHeight
    }
    let attributes: [NSAttributedString.Key: Any] = [
      .foregroundColor: Const.textColor,
      .font: Const.font,
      .paragraphStyle: style]
    details.attributedText = NSAttributedString(string: text, attributes: attributes)
  }
}
