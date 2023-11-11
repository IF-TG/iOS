//
//  PostCommentInputView.swift
//  travelPlan
//
//  Created by 양승현 on 11/11/23.
//

import UIKit

final class PostCommentInputView: InputTextView {
  // MARK: - Properties
  private let sendIcon = UIImageView(image: UIImage(named: "commentSend")?.setColor(.yg.gray2)).set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.contentMode = .scaleAspectFill
    $0.isHidden = true
  }
  
  // MARK: - Lifecycle
  convenience init() {
    let placeholderInfo = PlaceholderInfo(
      placeholderText: "댓글을 입력해주세요.",
      position: .centerY,
      inset: .init(top: 10, left: 10, bottom: 10, right: 40))
    self.init(frame: .zero, textContainer: nil, placeholderInfo: placeholderInfo)
    translatesAutoresizingMaskIntoConstraints = false
    textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 40)
  }
  
  override init(frame: CGRect, textContainer: NSTextContainer?, placeholderInfo: PlaceholderInfo) {
    super.init(frame: frame, textContainer: textContainer, placeholderInfo: placeholderInfo)
    configureUI()
  }
  
  required init?(coder: NSCoder) {
    nil
  }
  
  override var intrinsicContentSize: CGSize {
    return .init(width: 60, height: 40)
  }
}

// MARK: - Helpers
extension PostCommentInputView {
  func setPostCommentBorderStyle() {
    layer.cornerRadius = 12
    layer.backgroundColor = UIColor.yg.gray1.cgColor
    layer.borderWidth = 0.8
  }
}

// MARK: - Private Helpers
extension PostCommentInputView {
  private func configureUI() {
    setupUI()
  }
}

// MARK: - UITextViewDelegate
extension PostCommentInputView {
  override func textViewDidBeginEditing(_ textView: UITextView) {
    super.textViewDidBeginEditing(textView)
    sendIcon.isHidden = false
  }
  
  override func textViewDidEndEditing(_ textView: UITextView) {
    super.textViewDidEndEditing(textView)
    guard length <= 0 || text == nil else {
      return
    }
    sendIcon.isHidden = true
  }
}

// MARK: - LayoutSupport
extension PostCommentInputView: LayoutSupport {
  func addSubviews() {
    addSubview(sendIcon)
  }
  
  func setConstraints() {
    NSLayoutConstraint.activate(sendIconConstraints)
  }
  
  private var sendIconConstraints: [NSLayoutConstraint] {
    return [
      sendIcon.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
      sendIcon.centerYAnchor.constraint(equalTo: bottomAnchor, constant: -10),
      sendIcon.widthAnchor.constraint(equalToConstant: 20),
      sendIcon.heightAnchor.constraint(equalToConstant: 20)]
  }
}
