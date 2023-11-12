//
//  CommentInputView.swift
//  travelPlan
//
//  Created by 양승현 on 11/11/23.
//

import UIKit

protocol CommentInputViewDelegate: AnyObject {
  func didTapSendIcon(_ text: String)
}

final class CommentInputView: UIView {
  // MARK: - Properties
  private lazy var sendIcon = UIImageView(image: UIImage(named: "commentSend")?.setColor(.yg.gray2)).set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.contentMode = .scaleAspectFill
    $0.isHidden = true
    $0.isUserInteractionEnabled = true
    let tap = UITapGestureRecognizer(target: self, action: #selector(didTapSendIcon))
    $0.addGestureRecognizer(tap)
  }
  
  private let textView = {
    let placeholder = InputTextView.PlaceholderInfo(
      placeholderText: "댓글을 입력해주세요.",
      position: .centerY,
      inset: .init(top: 0, left: 10, bottom: 0, right: 40))
    let inputTextView = InputTextView(placeholderInfo: placeholder)
    inputTextView.font = UIFont(pretendard: .regular_400(fontSize: 14))
    inputTextView.placeholder.font = inputTextView.font
    inputTextView.textContainerInset = UIEdgeInsets(top: 10, left: 3.5, bottom: 10, right: 40)
    return inputTextView
  }()
  
  weak var commentDelegate: CommentInputViewDelegate?
  
  weak var textViewDelegate: UITextViewDelegate? {
    get {
      textView.delegate
    } set {
      textView.delegate = newValue
    }
  }
  
  // MARK: - Lifecycle
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureUI()
    textView.delegate = self
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
extension CommentInputView {
  func setPostCommentBorderStyle() {
    layer.cornerRadius = 12
    layer.borderColor = UIColor.yg.gray1.cgColor
    layer.borderWidth = 0.8
  }
  
  func clearInputText() {
    textView.text = nil
  }
}

// MARK: - Private Helpers
private extension CommentInputView {
  func configureUI() {
    setupUI()
  }
}

// MARK: - Action
extension CommentInputView {
  @objc func didTapSendIcon() {
    commentDelegate?.didTapSendIcon(textView.text)
  }
}

// MARK: - UITextViewDelegate
extension CommentInputView: UITextViewDelegate {
  func textViewDidBeginEditing(_ textView: UITextView) {
    sendIcon.isHidden = false
  }
  
  func textViewDidChange(_ textView: UITextView) {
    if textView.text == nil || textView.text.count == 0 {
      sendIcon.image = sendIcon.image?.setColor(.yg.gray2)
      sendIcon.isUserInteractionEnabled = false
    } else {
      sendIcon.image = sendIcon.image?.setColor(.yg.primary)
      sendIcon.isUserInteractionEnabled = true
    }
  }
  
  func textViewDidEndEditing(_ textView: UITextView) {
    guard textView.text.count <= 0 || textView.text == nil else {
      return
    }
    sendIcon.isHidden = true
  }
}

// MARK: - LayoutSupport
extension CommentInputView: LayoutSupport {
  func addSubviews() {
    [textView, sendIcon].forEach { addSubview($0) }
  }
  
  func setConstraints() {
    [sendIconConstraints, textViewConstraints].forEach { NSLayoutConstraint.activate($0) }
  }
  
  private var textViewConstraints: [NSLayoutConstraint] {
    return [
      textView.leadingAnchor.constraint(equalTo: leadingAnchor),
      textView.topAnchor.constraint(equalTo: topAnchor),
      textView.bottomAnchor.constraint(equalTo: bottomAnchor),
      textView.trailingAnchor.constraint(equalTo: trailingAnchor)]
  }
  
  private var sendIconConstraints: [NSLayoutConstraint] {
    return [
      sendIcon.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
      sendIcon.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
      sendIcon.widthAnchor.constraint(equalToConstant: 20),
      sendIcon.heightAnchor.constraint(equalToConstant: 20)]
  }
}
