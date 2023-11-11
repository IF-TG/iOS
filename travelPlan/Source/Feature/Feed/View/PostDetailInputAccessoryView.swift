//
//  PostDetailInputAccessoryView.swift
//  travelPlan
//
//  Created by 양승현 on 11/11/23.
//

import UIKit

final class PostDetailInputAccessoryView: UIView {
  // MARK: - Properties
  private let contentView = PostProfileAndCommentView()
  
  weak var commentInputViewDelegate: CommentInputViewDelegate? {
    get {
      contentView.commentInputViewDelegate
    } set {
      contentView.commentInputViewDelegate = newValue
    }
  }
  
  weak var textViewDelegate: UITextViewDelegate? {
    get {
      contentView.textViewDelegate
    } set {
      contentView.textViewDelegate = newValue
    }
  }
  
  weak var profileDelegate: BaseProfileAreaViewDelegate?
  
  // MARK: - Lifecycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  
  convenience init() {
    self.init(frame: .zero)
    translatesAutoresizingMaskIntoConstraints = false
  }
  
  required init?(coder: NSCoder) {
    nil
  }
}

// MARK: - Helpers
extension PostDetailInputAccessoryView {
  // TODO: - 로그인한 사용자는 프로필이미지 파일메니저나 캐싱으로 저장해두는게.. 그걸 가져오자
  func configure(with profileImageURL: String?) {
    contentView.configure(with: profileImageURL)
  }
}

// MARK: - LayoutSupport
extension PostDetailInputAccessoryView: LayoutSupport {
  func addSubviews() {
    addSubview(contentView)
  }
  
  func setConstraints() {
    NSLayoutConstraint.activate([
      contentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 11),
      contentView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
      contentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -11),
      contentView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)])
  }
}
