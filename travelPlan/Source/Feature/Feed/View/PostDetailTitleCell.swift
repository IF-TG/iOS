//
//  PostDetailTitleCell.swift
//  travelPlan
//
//  Created by 양승현 on 11/8/23.
//

import UIKit

final class PostDetailTitleCell: UITableViewCell {
  static let id = String(describing: PostDetailTitleCell.self)
  
  // MARK: - Properties
  private let titleLabel = BasePaddingLabel(
    padding: .init(top: 10, left: 20, bottom: 10, right: 20),
    fontType: .semiBold_600(fontSize: 30),
    lineHeight: 35.8
  ).set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.textColor = .yg.gray7
    $0.numberOfLines = 2
  }
  
  // MARK: - Lifecycle
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    selectionStyle = .none
    setupUI()
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
extension PostDetailTitleCell {
  func configure(with title: String?) {
    titleLabel.text = title
  }
}

// MARK: - LayoutSupport
extension PostDetailTitleCell: LayoutSupport {
  func addSubviews() {
    contentView.addSubview(titleLabel)
  }
  
  func setConstraints() {
    let bottomConstraint = titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
    bottomConstraint.priority = .init(999)
    NSLayoutConstraint.activate([
      titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
      titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      bottomConstraint])
  }
}
