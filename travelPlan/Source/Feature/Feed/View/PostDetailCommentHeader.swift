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
      constant: -8)
    commentViewBottomConstraint.priority = .defaultLow
    NSLayoutConstraint.activate([
      contentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 11),
      contentView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
      contentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -11),
      commentViewBottomConstraint])
  }
}
