//
//  PostDetailInputAccessoryWrapper.swift
//  travelPlan
//
//  Created by 양승현 on 11/11/23.
//

import UIKit

protocol PostDetailInputAccessoryWrapperDelegate: AnyObject {
  func didTouchSendIcon(_ text: String)
}

final class PostDetailInputAccessoryWrapper: UIView {
  // MARK: - Properties
  private let contentView = PostProfileAndCommentView()
  
  weak var delegate: PostDetailInputAccessoryWrapperDelegate?
  
  private let insets: UIEdgeInsets = .init(top: 10, left: 11, bottom: 10, right: 11)
  
  // MARK: - Lifecycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
    backgroundColor = .white
    contentView.inputDelegate = self
    contentView.baseDelegate = self
    configure(with: "tempProfile3")
  }
  
  override var intrinsicContentSize: CGSize {
    let size = contentView.intrinsicContentSize
    return CGSize(
      width: size.width + insets.left + insets.right,
      height: size.height + insets.top + insets.bottom)
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
extension PostDetailInputAccessoryWrapper {
  // TODO: - 로그인한 사용자니까,, 프로필이미지 파일메니저나 캐싱으로 저장해두는게.. 그걸 가져오자
  func configure(with profileImageURL: String?) {
    contentView.configure(with: profileImageURL)
  }
  
  func showKeyboard() {
    contentView.showKeyboard()
  }
  
  func hideKeyboard() {
    contentView.hideKeyboard()
  }
}

// MARK: - UITextViewDelegate
extension PostDetailInputAccessoryWrapper: UITextViewDelegate {
  func textViewDidEndEditing(_ textView: UITextView) {
    textView.resignFirstResponder()
  }
}

// MARK: - BaseProfileAreaViewDelegate
extension PostDetailInputAccessoryWrapper: BaseProfileAreaViewDelegate {
  func baseLeftRoundProfileAreaView(
    _ view: BaseProfileAreaView,
    didSelectProfileImage image: UIImage?
  ) {
    print("프로필 클릭")
  }
}

// MARK: - CommentInputViewDelegate
extension PostDetailInputAccessoryWrapper: CommentInputViewDelegate {
  func didTapSendIcon(_ text: String) {
    delegate?.didTouchSendIcon(text)
  }
}

// MARK: - LayoutSupport
extension PostDetailInputAccessoryWrapper: LayoutSupport {
  func addSubviews() {
    addSubview(contentView)
  }
  
  func setConstraints() {
    NSLayoutConstraint.activate([
      contentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets.left),
      contentView.topAnchor.constraint(equalTo: topAnchor, constant: insets.top),
      contentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -insets.right),
      contentView.bottomAnchor.constraint(
        equalTo: layoutMarginsGuide.bottomAnchor,
        constant: -insets.bottom)])
  }
}
