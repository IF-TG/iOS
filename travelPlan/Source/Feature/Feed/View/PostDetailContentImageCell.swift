//
//  PostDetailContentImageCell.swift
//  travelPlan
//
//  Created by 양승현 on 11/7/23.
//

import UIKit

final class PostDetailContentImageCell: UITableViewCell {
  enum Constant {
    static let spacing: CGFloat = 10
  }
  
  // MARK: - Properties
  private let contentImageView = UIImageView(frame: .zero).set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.contentMode = .scaleAspectFill
    $0.layer.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
    $0.layer.cornerRadius = 20
  }
  
  // MARK: - Lifecycle
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
  }
  
  required init?(coder: NSCoder) {
    nil
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
    if Int(contentImageView.layer.cornerRadius) != Int(0) {
      UIView.animate(
        withDuration: 0.32,
        delay: 0,
        options: .curveEaseOut,
        animations: {
          self.contentImageView.layer.cornerRadius = 0
        })
    }
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
    return [
      contentImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constant.spacing),
      contentImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constant.spacing),
      contentImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constant.spacing)]
  }
}
