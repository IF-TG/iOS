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
  
  private let inputTextView: InputTextView = {
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
  
  weak var textViewDelegate: UITextViewDelegate? {
    get {
      inputTextView.delegate
    } set {
      inputTextView.delegate = newValue
    }
  }
  
  weak var commentDelegate: CommentInputViewDelegate?
  
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
    commentDelegate?.didTapSendIcon(inputTextView.text)
    inputTextView.text = nil
  }
}

// MARK: - UITextViewDelegate
/// delegate = self를 했지만, delegate를 커스텀할 때는 이 함수들을 호출해야합니다.
extension CommentInputView: UITextViewDelegate {
  func textViewDidBeginEditing(_ textView: UITextView) {
    inputTextView.textViewDidBeginEditing(textView)
    sendIcon.isHidden = false
  }
  
  func textViewDidChange(_ textView: UITextView) {
    inputTextView.textViewDidChange(textView)
    if textView.text == nil || textView.text.count == 0 {
      sendIcon.image = sendIcon.image?.setColor(.yg.gray2)
      sendIcon.isUserInteractionEnabled = false
    } else {
      sendIcon.image = sendIcon.image?.setColor(.yg.primary)
      sendIcon.isUserInteractionEnabled = true
    }
  }
  
  func textViewDidEndEditing(_ textView: UITextView) {
    inputTextView.textViewDidEndEditing(textView)
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
      sendIcon.widthAnchor.constraint(equalToConstant: 20),
      sendIcon.heightAnchor.constraint(equalToConstant: 20)]
  }
}
