//
//  BaseNotificationCell.swift
//  travelPlan
//
//  Created by 양승현 on 11/1/23.
//

import UIKit

protocol BaseNotificationCellDelegate: AnyObject {
  func baseNotificationCell(
    _ cell: BaseNotificationCell,
    didTapCloseIcon icon: UIImageView)
}

class BaseNotificationCell: UITableViewCell {
  enum Constant {
    enum Icon {
      static let size = CGSize(width: 24, height: 24)
      enum Spacing {
        static let leading: CGFloat = 16
        static let top: CGFloat = 20
      }
    }
    enum BaseContentView {
      enum Spacing {
        static let leading: CGFloat = 13
        static let top: CGFloat = 15
        static let bottom: CGFloat = 15
        static let trailing: CGFloat = 37
      }
    }
    enum CloseIcon {
      static let size = CGSize(width: 20, height: 20)
      enum Spacing {
        static let leading: CGFloat = 8
        static let top: CGFloat = 15
        static let trailing: CGFloat = 9
      }
    }
    enum CellDivider {
      static let backgroundColor: UIColor = .yg.gray0
      static let height: CGFloat = 1
    }
  }
  
  // MARK: - Properties
  private let icon = UIImageView().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.contentMode = .scaleAspectFit
  }
  
  private let baseContentView: UIView
  
  private lazy var closeIcon = UIImageView(frame: .zero).set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.image = UIImage(named: "cancel")
    $0.contentMode = .scaleAspectFill
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapCloseButton))
    $0.addGestureRecognizer(tapGesture)
  }
  
  private let cellDivider = UIView(frame: .zero).set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = Constant.CellDivider.backgroundColor
  }
  
  weak var delegate: BaseNotificationCellDelegate?
  
  // MARK: - Lifecycle
  // useageTODO: - 오버라이드 해서 baseContentView의 인스턴스를 초기화 해야합니다.
  init(
    baseContentView: UIView,
    style: UITableViewCell.CellStyle,
    reuseIdentifier: String?
  ) {
    self.baseContentView = baseContentView
    self.baseContentView.translatesAutoresizingMaskIntoConstraints = false
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    configureUI()
  }
  
  required init?(coder: NSCoder) {
    nil
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    baseConfigure(with: nil)
  }
}

// MARK: - Helpers
extension BaseNotificationCell {
  func baseConfigure(with imagePath: String?) {
    guard let imagePath else {
      icon.image = nil
      return
    }
    icon.image = UIImage(named: imagePath)
  }
}

// MARK: - Private Helpers
private extension BaseNotificationCell {
  func configureUI() {
    selectionStyle = .none
    setupUI()
    setSubviewsPriority()
  }
  
  func setSubviewsPriority() {
    icon.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    baseContentView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    closeIcon.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    
    icon.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    baseContentView.setContentHuggingPriority(.defaultLow, for: .horizontal)
    closeIcon.setContentHuggingPriority(.defaultHigh, for: .horizontal)
  }
}

// MARK: - Actions
private extension BaseNotificationCell {
  @objc func didTapCloseButton(_ sender: Any) {
    delegate?.baseNotificationCell(self, didTapCloseIcon: closeIcon)
  }
}

// MARK: - LayoutSupport
extension BaseNotificationCell: LayoutSupport {
  func addSubviews() {
    _=[
      icon,
      baseContentView,
      closeIcon,
      cellDivider
    ].map {
      contentView.addSubview($0)
    }
  }
  
  func setConstraints() {
    _=[
      iconConstraints,
      baseContentViewConstraints,
      closeIconConstraints,
      cellDividerConstraints
    ].map {
      NSLayoutConstraint.activate($0)
    }
  }
}

// MARK: - LayoutSupport Constraints
private extension BaseNotificationCell {
  var iconConstraints: [NSLayoutConstraint] {
    typealias Const = Constant.Icon
    typealias Spacing = Const.Spacing
    return [
      icon.leadingAnchor.constraint(
        equalTo: contentView.leadingAnchor,
        constant: Spacing.leading),
      icon.topAnchor.constraint(
        equalTo: contentView.topAnchor,
        constant: Spacing.top),
      icon.widthAnchor.constraint(equalToConstant: Const.size.width),
      icon.heightAnchor.constraint(equalToConstant: Const.size.height)]
  }
  
  var baseContentViewConstraints: [NSLayoutConstraint] {
    typealias Spacing = Constant.BaseContentView.Spacing
    let bottomConstraint = baseContentView.bottomAnchor.constraint(
      equalTo: contentView.bottomAnchor,
      constant: -Spacing.bottom)
    bottomConstraint.priority = .defaultHigh
    return [
      baseContentView.leadingAnchor.constraint(
        equalTo: icon.trailingAnchor,
        constant: Spacing.leading),
      baseContentView.topAnchor.constraint(
        equalTo: contentView.topAnchor,
        constant: Spacing.top),
      baseContentView.trailingAnchor.constraint(
        equalTo: contentView.trailingAnchor,
        constant: -Spacing.trailing),
      bottomConstraint]
  }
  
  var closeIconConstraints: [NSLayoutConstraint] {
    typealias Const = Constant.CloseIcon
    typealias Spacing = Const.Spacing
    return [
      closeIcon.trailingAnchor.constraint(
        equalTo: contentView.trailingAnchor,
        constant: -Spacing.trailing),
      closeIcon.topAnchor.constraint(
        equalTo: contentView.topAnchor,
        constant: Spacing.top),
      closeIcon.widthAnchor.constraint(equalToConstant: Const.size.width),
      closeIcon.heightAnchor.constraint(equalToConstant: Const.size.height)]
  }
  
  var cellDividerConstraints: [NSLayoutConstraint] {
    typealias Const = Constant.CellDivider
    return [
      cellDivider.leadingAnchor.constraint(
        equalTo: contentView.leadingAnchor, 
        constant: Const.height),
      cellDivider.bottomAnchor.constraint(
        equalTo: contentView.bottomAnchor,
        constant: -Const.height),
      cellDivider.trailingAnchor.constraint(
        equalTo: contentView.trailingAnchor),
      cellDivider.heightAnchor.constraint(equalToConstant: Const.height)]
  }
}
