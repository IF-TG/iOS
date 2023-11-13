//
//  PostDetailInputAccessoryView.swift
//  travelPlan
//
//  Created by 양승현 on 11/11/23.
//

import UIKit

protocol PostDetailInputAccessoryViewDelegate: AnyObject {
  func didTouchSendIcon(_ text: String)
}

final class PostDetailInputAccessoryView: UIView {
  // MARK: - Properties
  private let maximumTextLine = 3
  
  private lazy var originalHeight = textLineHeight + 20
  
  private lazy var prevHeight = originalHeight
  
  private var lineHeight: CGFloat {
    contentView.textLineheight
  }
  
  private var prevNumberOfLines: Int = 0
  
  private let contentView = PostProfileAndCommentView()
  
  weak var inputDelegate: PostDetailInputAccessoryViewDelegate?
  
  weak var textViewDelegate: UITextViewDelegate? {
    get {
      contentView.textViewDelegate
    } set {
      contentView.textViewDelegate = newValue
    }
  }
  
  weak var profileDelegate: BaseProfileAreaViewDelegate?
  
  var textLineHeight: CGFloat {
    contentView.textLineheight
  }
  
  private var contentViewHeightConstraint: NSLayoutConstraint!
  
  // MARK: - Lifecycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
    contentView.textViewDelegate = self
    contentView.commentInputViewDelegate = self
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

// MARK: - Private Helpers
private extension PostDetailInputAccessoryView {
  func isIncreasedTextLine(from estimatedHeight: CGFloat) -> Bool {
    return estimatedHeight <= originalHeight + textLineHeight * CGFloat(maximumTextLine)
  }
  
  func isDecreasedTextLine(from newLineCount: Int) -> Bool {
    return newLineCount >= 1 && newLineCount < prevNumberOfLines
  }
  
  func isChangedTextLine(from estimatedHeight: CGFloat) -> Bool {
    return prevHeight != estimatedHeight
  }
  
  func updateContentViewHeight(from height: CGFloat) {
    contentViewHeightConstraint.isActive = false
    contentViewHeightConstraint = contentView.heightAnchor.constraint(equalToConstant: height)
    contentViewHeightConstraint.isActive = true
    self.contentView.layoutIfNeeded()
  }
  
  func updateCursorPositionToUpperLine(_ textView: UITextView, from offsetY: CGFloat) {
    let offset = CGPoint(x: 0, y: offsetY)
    textView.setContentOffset(offset, animated: false)
  }
}

// MARK: - UITextViewDelegate
extension PostDetailInputAccessoryView: UITextViewDelegate {
  func textViewDidChange(_ textView: UITextView) {
    contentView.textViewDidChange(textView)
    let newLineCount = textView.text.components(separatedBy: "\n").count - 1
    
    if prevNumberOfLines != newLineCount {
      if isDecreasedTextLine(from: newLineCount) {
        let upperOffsetY = textView.contentOffset.y - lineHeight
        updateCursorPositionToUpperLine(textView, from: upperOffsetY)
        if newLineCount == 1 {
          updateContentViewHeight(from: textView.bounds.height - lineHeight)
          prevNumberOfLines = newLineCount
          return
        }
      }
      prevNumberOfLines = newLineCount
    }
    
    let estimatedHeight = textView.sizeThatFits(.init(width: textView.bounds.width, height: CGFloat.infinity)).height
    guard isChangedTextLine(from: estimatedHeight) else { return }
    if isIncreasedTextLine(from: estimatedHeight) {
      updateContentViewHeight(from: estimatedHeight)
      prevHeight = estimatedHeight
    }
  }
  
  func textViewDidBeginEditing(_ textView: UITextView) {
    contentView.textViewDidBeginEditing(textView)
  }
  
  func textViewDidEndEditing(_ textView: UITextView) {
    contentView.textViewDidEndEditing(textView)
  }
}

// MARK: - CommentInputViewDelegate
extension PostDetailInputAccessoryView: CommentInputViewDelegate {
  func didTapSendIcon(_ text: String) {
    inputDelegate?.didTouchSendIcon(text)
    updateContentViewHeight(from: originalHeight)
  }
}

// MARK: - LayoutSupport
extension PostDetailInputAccessoryView: LayoutSupport {
  func addSubviews() {
    addSubview(contentView)
  }
  
  func setConstraints() {
    contentViewHeightConstraint = contentView.heightAnchor.constraint(equalToConstant: originalHeight)
    NSLayoutConstraint.activate([
      contentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 11),
      contentView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
      contentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -11),
      contentView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
      contentViewHeightConstraint])
  }
}
