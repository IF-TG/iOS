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
    didTapCloseButton button: UIButton)
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
        
      }
    }
    enum CloseButton {
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
  
  private let baseContentView = UIView().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  
  private lazy var closeButton = UIButton(frame: .zero).set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
  }
  
  private let cellDivider = UIView(frame: .zero).set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = Constant.CellDivider.backgroundColor
  }
  
  weak var delegate: BaseNotificationCellDelegate?
  
  // MARK: - Lifecycle
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    selectionStyle = .none
  }
  
  required init?(coder: NSCoder) {
    nil
  }
}
// MARK: - Helpers

// MARK: - Actions
private extension BaseNotificationCell {
  @objc func didTapCloseButton(_ sender: Any) {
    delegate?.baseNotificationCell(self, didTapCloseButton: closeButton)
  }
}

// MARK: - LayoutSupport
extension BaseNotificationCell: LayoutSupport {
  func addSubviews() {
    _=[
      icon,
      baseContentView,
      closeButton,
      cellDivider
    ].map {
      contentView.addSubview($0)
    }
  }
  
  func setConstraints() {
    _=[
      iconConstraints,
      baseContentViewConstraints,
      closeButtonConstraints,
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
      bottomConstraint]
  }
  
  var closeButtonConstraints: [NSLayoutConstraint] {
    typealias Const = Constant.CloseButton
    typealias Spacing = Const.Spacing
    return [
      closeButton.trailingAnchor.constraint(
        equalTo: contentView.trailingAnchor,
        constant: -Spacing.trailing),
      closeButton.topAnchor.constraint(
        equalTo: contentView.topAnchor,
        constant: Spacing.top),
      closeButton.widthAnchor.constraint(equalToConstant: Const.size.width),
      closeButton.heightAnchor.constraint(equalToConstant: Const.size.height)]
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
