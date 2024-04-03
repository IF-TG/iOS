//
//  PostDetailCommentHeader.swift
//  travelPlan
//
//  Created by 양승현 on 11/9/23.
//

import UIKit

protocol PostDetailCommentDelegate: AnyObject {
  func didTapHeart(_ header: UITableViewHeaderFooterView, _ isOnHeart: Bool)
  func didTapCanceledHeart(_ header: UITableViewHeaderFooterView)
  func didTapReply(_ header: UITableViewHeaderFooterView)
  func didTapProfile(_ header: UITableViewHeaderFooterView)
}

final class PostDetailCommentHeader: UITableViewHeaderFooterView {
  static let id = String(describing: PostDetailCommentHeader.self)
  
  // MARK: - Properties
  private let commentView = BasePostDetailCommentableView(usageType: .comment)
  // TODO: - delete control 추가해야합니다.
  
  weak var delegate: PostDetailCommentDelegate?
  
  // MARK: - Lifecycle
  override init(reuseIdentifier: String?) {
    super.init(reuseIdentifier: reuseIdentifier)
    configureUI()
    commentView.delegate = self
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

// MARK: - BaseCommentViewDelegate
extension PostDetailCommentHeader: BaseCommentViewDelegate {
  func didTapHeart(_ isOnHeart: Bool) {
    delegate?.didTapHeart(self, isOnHeart)
  }
  
  func didCanceledHeart() {
    delegate?.didTapCanceledHeart(self)
  }
  
  func didTapReply() {
    delegate?.didTapReply(self)
  }
  
  func didTapProfile() {
    delegate?.didTapProfile(self)
  }
}

// MARK: - LayoutSupport
extension PostDetailCommentHeader: LayoutSupport {
  func addSubviews() {
    [commentView].forEach {
      addSubview($0)
    }
  }
  
  func setConstraints() {
    let commentViewBottomConstraint = commentView.bottomAnchor.constraint(
      equalTo: bottomAnchor,
      constant: -10)
    commentViewBottomConstraint.priority = .defaultHigh
    NSLayoutConstraint.activate([
      commentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 11),
      commentView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
      commentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -11),
      commentViewBottomConstraint])
  }
}
