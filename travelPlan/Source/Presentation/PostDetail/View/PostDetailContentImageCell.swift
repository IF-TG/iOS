//
//  PostDetailContentImageCell.swift
//  travelPlan
//
//  Created by 양승현 on 11/7/23.
//

import UIKit

final class PostDetailContentImageCell: UITableViewCell {
  static let id = String(describing: PostDetailContentImageCell.self)
  
  enum Constant {
    static let imageHeight: CGFloat = 235
  }
  
  // MARK: - Properties
  private let contentImageView = UIImageView(frame: .zero).set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.contentMode = .scaleAspectFill
    $0.layer.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
    $0.clipsToBounds = true
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
extension PostDetailContentImageCell {
  func configure(with imagePath: String?) {
    guard let imagePath else {
      contentImageView.image = nil
      return
    }
    contentImageView.image = UIImage(named: imagePath)
  }
}

// MARK: - Private Helpers
private extension PostDetailContentImageCell {
  func configureUI() {
    selectionStyle = .none
    setupUI()
  }
}

// MARK: - LayoutSupport
extension PostDetailContentImageCell: LayoutSupport {
  func addSubviews() {
    contentView.addSubview(contentImageView)
  }
  
  func setConstraints() {
    NSLayoutConstraint.activate(contentImageViewConstraints)
  }
}

// MARK: - LayoutSupport Constraints
private extension PostDetailContentImageCell {
  var contentImageViewConstraints: [NSLayoutConstraint] {
    let contentImageViewBottomConstriant = contentImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
    contentImageViewBottomConstriant.priority = .init(999)
    return [
      contentImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
      contentImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
      contentImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
      contentImageView.heightAnchor.constraint(equalToConstant: Constant.imageHeight),
      contentImageViewBottomConstriant]
  }
}
