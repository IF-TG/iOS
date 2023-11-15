//
//  PostDetailContentTextCell.swift
//  travelPlan
//
//  Created by 양승현 on 11/7/23.
//

import UIKit

final class PostDetailContentTextCell: UITableViewCell {
  static let id = String(describing: PostDetailContentTextCell.self)
  
  // MARK: - Properties
  private lazy var label = UITextView(frame: .zero, textContainer: nil).set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.isScrollEnabled = false
    $0.font = UIFont(pretendard: .regular_400(fontSize: 16))
    $0.setDraggingGestureToCopyInClipboard()
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
    let labelBottomConstraint = label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
    labelBottomConstraint.priority = .defaultHigh
    return [
      label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 11),
      label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
      label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -11),
      labelBottomConstraint]
  }
}
