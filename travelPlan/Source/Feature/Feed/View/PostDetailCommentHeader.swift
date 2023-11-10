//
//  PostDetailCommentHeader.swift
//  travelPlan
//
//  Created by 양승현 on 11/9/23.
//

import UIKit

final class PostDetailCommentHeader: UITableViewHeaderFooterView {
  static let id = String(describing: PostDetailCommentHeader.self)
  
  // MARK: - Properties
  private let commentView = BasePostDetailCommentableView(usageType: .comment)
  // TODO: - delete control 추가해야합니다.
  
  weak var delegate: BaseCommentViewDelegate? {
    get {
      commentView.delegate
    } set {
      commentView.delegate = newValue
    }
  }
  
  // MARK: - Lifecycle
  override init(reuseIdentifier: String?) {
    super.init(reuseIdentifier: reuseIdentifier)
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
extension PostDetailCommentHeader {
  func configure(with info: BasePostDetailCommentInfo?) {
    commentView.configure(with: info)
  }
}

// MARK: - Private Helpers
extension PostDetailCommentHeader {
  private func configureUI() {
    setupUI()
  }
}

// MARK: - LayoutSupport
extension PostDetailCommentHeader: LayoutSupport {
  func addSubviews() {
    [commentView].forEach {
      contentView.addSubview($0)
    }
  }
  
  func setConstraints() {
    let commentViewBottomConstraint = commentView.bottomAnchor.constraint(
      equalTo: contentView.bottomAnchor,
      constant: -10)
    commentViewBottomConstraint.priority = .defaultHigh
    NSLayoutConstraint.activate([
      commentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 11),
      commentView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
      commentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -11),
      commentViewBottomConstraint])
  }
}
