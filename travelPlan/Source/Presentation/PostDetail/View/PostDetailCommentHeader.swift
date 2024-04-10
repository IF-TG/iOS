//
//  PostDetailCommentHeader.swift
//  travelPlan
//
//  Created by 양승현 on 11/9/23.
//

import UIKit

protocol PostDetailCommentHeaderIdentifiable {
  var section: Int? { get }
}

protocol PostDetailCommentDelegate: AnyObject {
  func didTapHeart(_ header: PostDetailCommentHeaderIdentifiable, _ isOnHeart: Bool)
  func didTapCanceledHeart(_ header: PostDetailCommentHeaderIdentifiable)
  func didTapReply(_ header: PostDetailCommentHeaderIdentifiable)
  func didTapProfile(_ header: PostDetailCommentHeaderIdentifiable)
}

final class PostDetailCommentHeader: UITableViewHeaderFooterView & PostDetailCommentHeaderIdentifiable {
  
  static let id = String(describing: PostDetailCommentHeader.self)
  
  // MARK: - Properties
  private let commentView = BasePostDetailCommentableView(usageType: .comment)
  // TODO: - delete control 추가해야합니다.
  
  private let optionView = UIView(frame: .zero).set {
    $0.backgroundColor = .yellow
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  
  var section: Int?
  
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
    configure(with: nil, section: nil)
  }
}

// MARK: - Helpers
extension PostDetailCommentHeader {
  func configure(with info: BasePostDetailCommentInfo?, section: Int?) {
    commentView.configure(with: info)
    self.section = section
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
  func didTapOption() {
    print("옵션눌러버림")
  }
  
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
    [commentView, optionView].forEach {
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
      commentViewBottomConstraint,
    
      optionView.widthAnchor.constraint(equalToConstant: 22),
      optionView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.4),
      optionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      optionView.topAnchor.constraint(equalTo: contentView.topAnchor)])
  }
}
