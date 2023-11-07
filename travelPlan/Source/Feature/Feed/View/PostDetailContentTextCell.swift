//
//  PostDetailContentTextCell.swift
//  travelPlan
//
//  Created by 양승현 on 11/7/23.
//

import UIKit

final class PostDetailContentTextCell: UITableViewCell {
  static let id = String(describing: PostDetailContentTextCell.self)
  
  enum Constant {
    static let spacing: CGFloat = 10
  }
  
  // MARK: - Properties
  private let label = BaseLabel(fontType: .regular_400(fontSize: 14), lineHeight: 25)
  
  private var labelBottomConstraint: NSLayoutConstraint!

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
extension PostDetailContentTextCell {
  func configure(with text: String?) {
    label.text = text
  }
}

// MARK: - Private Helpers
private extension PostDetailContentTextCell {
  func configureUI() {
    selectionStyle = .none
    setupUI()
  }
}

// MARK: - Actions

// MARK: - LayoutSupport
extension PostDetailContentTextCell: LayoutSupport {
  func addSubviews() {
    contentView.addSubview(label)
  }
  
  func setConstraints() {
    NSLayoutConstraint.activate(labelConstriants)
  }
}

// MARK: - LayoutSupport Constraints
private extension PostDetailContentTextCell {
  private var labelConstriants: [NSLayoutConstraint] {
    labelBottomConstraint = label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
    labelBottomConstraint.priority = .defaultHigh
    return [
      label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constant.spacing),
      label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constant.spacing),
      label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constant.spacing),
      labelBottomConstraint]
  }
}
