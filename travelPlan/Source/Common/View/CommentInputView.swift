//
//  CommentInputView.swift
//  travelPlan
//
//  Created by 양승현 on 11/11/23.
//

import UIKit

protocol CommentInputViewDelegate: UITextViewDelegate {
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
  
  private lazy var inputTextView: InputTextView = {
    let placeholder = InputTextView.PlaceholderInfo(
      placeholderText: "댓글을 입력해주세요.",
      position: .centerY,
      inset: .init(top: 0, left: 10, bottom: 0, right: 40))
    let inputTextView = InputTextView(placeholderInfo: placeholder)
    inputTextView.font = UIFont(pretendard: .regular_400(fontSize: 14))
    inputTextView.placeholder.font = inputTextView.font
    inputTextView.textContainerInset = UIEdgeInsets(top: 10, left: 3.5, bottom: 10, right: 40)
    inputTextView.maxHeight = 20 + lineHeight * 3
    return inputTextView
  }()
  
  weak var delegate: CommentInputViewDelegate?
  
  var lineHeight: CGFloat {
    UIFont(pretendard: .regular_400(fontSize: 14))!.lineHeight
  }
  
  // MARK: - Lifecycle
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureUI()
    inputTextView.delegate = self
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
  func activeScrollableContent() {
    inputTextView.isScrollEnabled = true
  }
  
  func deactiveScrollableContent() {
    inputTextView.isScrollEnabled = false
  }
  
  func showKeyboard() {
    inputTextView.becomeFirstResponder()
  }
  
  func hideKeyboard() {
    inputTextView.resignFirstResponder()
  }
  
  func setScrollEnabled(_ value: Bool) {
    inputTextView.isScrollEnabled = value
  }
}

// MARK: - Private Helpers
private extension CommentInputView {
  func configureUI() {
    setupUI()
    layer.cornerRadius = 12
    layer.borderColor = UIColor.yg.gray1.cgColor
    layer.borderWidth = 0.8
  }
}

// MARK: - Action
extension CommentInputView {
  @objc func didTapSendIcon() {
    delegate?.didTapSendIcon(inputTextView.text)
    inputTextView.text = nil
    sendIcon.image = sendIcon.image?.setColor(.yg.gray2)
  }
}

// MARK: - UITextViewDelegate
extension CommentInputView: UITextViewDelegate {
  func textViewDidBeginEditing(_ textView: UITextView) {
    delegate?.textViewDidBeginEditing?(textView)
    sendIcon.isHidden = false
  }
  
  func textViewDidChange(_ textView: UITextView) {
    delegate?.textViewDidChange?(textView)
    if textView.text == nil || textView.text.count == 0 {
      sendIcon.image = sendIcon.image?.setColor(.yg.gray2)
      sendIcon.isUserInteractionEnabled = false
    } else {
      sendIcon.image = sendIcon.image?.setColor(.yg.primary)
      sendIcon.isUserInteractionEnabled = true
    }
  }
  
  func textViewDidEndEditing(_ textView: UITextView) {
    delegate?.textViewDidEndEditing?(textView)
    guard textView.text.count <= 0 || textView.text == nil else {
      return
    }
    sendIcon.isHidden = true
  }
}

// MARK: - LayoutSupport
extension CommentInputView: LayoutSupport {
  func addSubviews() {
    [inputTextView, sendIcon].forEach { addSubview($0) }
  }
  
  func setConstraints() {
    [sendIconConstraints, textViewConstraints].forEach { NSLayoutConstraint.activate($0) }
  }
  
  private var textViewConstraints: [NSLayoutConstraint] {
    return [
      inputTextView.leadingAnchor.constraint(equalTo: leadingAnchor),
      inputTextView.topAnchor.constraint(equalTo: topAnchor),
      inputTextView.bottomAnchor.constraint(equalTo: bottomAnchor),
      inputTextView.trailingAnchor.constraint(equalTo: trailingAnchor)]
  }
  
  private var sendIconConstraints: [NSLayoutConstraint] {
    return [
      sendIcon.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
      sendIcon.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
      sendIcon.widthAnchor.constraint(equalToConstant: 17),
      sendIcon.heightAnchor.constraint(equalToConstant: 17)]
  }
}
