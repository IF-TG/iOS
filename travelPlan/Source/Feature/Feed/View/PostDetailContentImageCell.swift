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
    static let spacing: CGFloat = 10
    static let imageHeight: CGFloat = 235
  }
  
  // MARK: - Properties
  private let contentImageView = UIImageView(frame: .zero).set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.contentMode = .scaleAspectFill
    $0.layer.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
    $0.layer.cornerRadius = 20
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
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.35, execute: {
      /// 서버에서 0.3초 늦게 이미지를 받아온다고 가정.:
      self.contentImageView.image = UIImage(named: imagePath)
      if Int(self.contentImageView.layer.cornerRadius) != Int(0) {
        UIView.animate(
          withDuration: 0.32,
          delay: 0,
          options: .curveEaseOut,
          animations: {
            self.contentImageView.layer.cornerRadius = 0
          })
      }
    })
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
      contentImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constant.spacing),
      contentImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constant.spacing),
      contentImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constant.spacing),
      contentImageView.heightAnchor.constraint(equalToConstant: Constant.imageHeight),
      contentImageViewBottomConstriant]
  }
}
