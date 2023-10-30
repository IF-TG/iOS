//
//  NoticeCell.swift
//  travelPlan
//
//  Created by 양승현 on 10/29/23.
//

import UIKit

struct NoticeCellInfo {
  let title: String
  let date: String
  let details: String
  var isExpended: Bool
}

final class NoticeCell: UITableViewCell {
  static let id = String(describing: NoticeCell.self)
  
  enum Constant {
    enum TitleLabel {
      static let font = UIFont(pretendard: .regular, size: 15)
      static let fontColor = UIColor.yg.gray5
      enum Spacing {
        static let leading: CGFloat = 12
        static let top: CGFloat = 15
        static let trailing: CGFloat = 60
      }
    }
    enum ChevronIcon {
      static let size = CGSize(width: 24, height: 24)
      enum Spacing {
        static let trailing: CGFloat = 10
      }
    }
    enum DateLabel {
      static let font = UIFont(pretendard: .regular, size: 15)
      static let fontColor = UIColor.yg.gray3
      enum Spacing {
        static let leading: CGFloat = 12
      }
    }
    enum CellDivider {
      static let color = UIColor.yg.gray0
      static let height: CGFloat = 1
      enum Spacing {
        static let top: CGFloat = 14
      }
    }
    enum DetailsLabel {
      static let backgroundColor = UIColor.yg.gray00Background
      static let inset = UIEdgeInsets(top: 20, left: 11, bottom: 20, right: 11)
      static let font = UIFont(pretendard: .regular, size: 15)
      static let attributes: [NSAttributedString.Key: Any] = {
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineHeightMultiple = 1.28
        return [.paragraphStyle: paragraph]
      }()
    }
  }
  
  // MARK: - Properties
  private let titleLabel = UILabel(frame: .zero).set {
    typealias Const = Constant.TitleLabel
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.font = Const.font
    $0.textColor = Const.fontColor
    $0.numberOfLines = 2
  }
  
  private let chevronIcon = UIImageView().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.image = UIImage(named: "chevron")
  }
  
  private let dateLabel = UILabel(frame: .zero).set {
    typealias Const = Constant.DateLabel
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.font = Const.font
    $0.textColor = Const.fontColor
    $0.numberOfLines = 1
  }
  
  private let cellDivider = UIView(frame: .zero).set {
    typealias Const = Constant.CellDivider
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = Const.color
  }
  
  private let detailsLabel = BasePaddingLabel(padding: Constant.DetailsLabel.inset).set {
    typealias Const = Constant.DetailsLabel
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.font = Const.font
    $0.backgroundColor = Const.backgroundColor
    $0.numberOfLines = 0
  }
  
  private var notExpendedConstraints: [NSLayoutConstraint] = []
  
  private var expendedConstriants: [NSLayoutConstraint] = []
  
  var isExpended = false {
    didSet {
      updateVisibleLayout()
      updateChevronRotation()
    }
  }
  
  // MARK: - Lifecycle
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    configureUI()
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
extension NoticeCell {
  func configure(with info: NoticeCellInfo?) {
    titleLabel.text = info?.title
    dateLabel.text = info?.date
    detailsLabel.text = info?.details
    isExpended = info?.isExpended ?? false
    detailsLabel.alpha = CGFloat(isExpended.toInt)
  }
}

// MARK: - Private Helpers
private extension NoticeCell {
  func configureUI() {
    setupUI()
    setHuggingPriority()
    selectionStyle = .none
  }
  
  func updateVisibleLayout() {
    if isExpended {
      NSLayoutConstraint.deactivate(notExpendedConstraints)
      NSLayoutConstraint.activate(expendedConstriants)
    } else {
      NSLayoutConstraint.deactivate(expendedConstriants)
      NSLayoutConstraint.activate(notExpendedConstraints)
    }
    detailsLabel.alpha = CGFloat(isExpended.toInt)
  }
  
  func setHuggingPriority() {
    titleLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
    dateLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
  }
  
  func updateChevronRotation() {
    UIView.animate(
      withDuration: 0.24,
      delay: .zero,
      options: .curveEaseOut,
      animations: { [unowned self] in
        chevronIcon.transform = isExpended ? .init(rotationAngle: .pi-0.00000000001) : .identity
      })
  }
  
  func setReferenceConstraints() {
    let cellDividerBottomConstraint = cellDivider.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
    cellDividerBottomConstraint.priority = .defaultHigh
    
    let detailsLabelBottomConstraint = detailsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
    detailsLabelBottomConstraint.priority = .defaultHigh
    
    notExpendedConstraints = [
      cellDividerBottomConstraint,
      detailsLabel.topAnchor.constraint(equalTo: cellDivider.bottomAnchor, constant: -12)]
    expendedConstriants = [
      detailsLabelBottomConstraint,
      detailsLabel.topAnchor.constraint(equalTo: cellDivider.bottomAnchor)]
  }
}

// MARK: - LayoutSupport
extension NoticeCell: LayoutSupport {
  func addSubviews() {
    _=[
      titleLabel,
      chevronIcon,
      dateLabel,
      cellDivider,
      detailsLabel
    ].map {
      contentView.addSubview($0)
    }
  }
  
  func setConstraints() {
    let sharedConstraints: [NSLayoutConstraint] = [
      titleLabelConstraints,
      dateLabelConstraints,
      chevronIconConstraints,
      cellDividerConstraints,
      detailsLabelConstraints
    ].flatMap { $0 }
    
    setReferenceConstraints()
    
    NSLayoutConstraint.activate([sharedConstraints + notExpendedConstraints].flatMap { $0 })
  }
}

// MARK: - LayoutSupport Constraints
private extension NoticeCell {
  var titleLabelConstraints: [NSLayoutConstraint] {
    typealias Spacing = Constant.TitleLabel.Spacing
    return [
      titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Spacing.leading),
      titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Spacing.top),
      titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Spacing.trailing)]
  }
  
  var dateLabelConstraints: [NSLayoutConstraint] {
    typealias Spacing = Constant.DateLabel.Spacing
    return [
      dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Spacing.leading),
      dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
      dateLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor)]
  }
  
  var chevronIconConstraints: [NSLayoutConstraint] {
    typealias Const = Constant.ChevronIcon
    typealias Spacing = Const.Spacing
    return [
      chevronIcon.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Spacing.trailing),
      chevronIcon.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
      chevronIcon.widthAnchor.constraint(equalToConstant: Const.size.width),
      chevronIcon.heightAnchor.constraint(equalToConstant: Const.size.height)]
  }
  
  var cellDividerConstraints: [NSLayoutConstraint] {
    typealias Const = Constant.CellDivider
    typealias Spacing = Const.Spacing
    return [
      cellDivider.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      cellDivider.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: Spacing.top),
      cellDivider.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      cellDivider.heightAnchor.constraint(equalToConstant: Const.height)]
  }
  
  var detailsLabelConstraints: [NSLayoutConstraint] {
    return [
      detailsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      detailsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)]
  }
}
