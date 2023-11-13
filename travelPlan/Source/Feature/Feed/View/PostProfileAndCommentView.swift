//
//  PostProfileAndCommentView.swift
//  travelPlan
//
//  Created by 양승현 on 11/11/23.
//

import UIKit

final class PostProfileAndCommentView: BaseProfileAreaView {
  // MARK: - Properties
  private let commentInputView = CommentInputView()
  
  weak var commentInputViewDelegate: CommentInputViewDelegate? {
    get {
      commentInputView.commentDelegate
    } set {
      commentInputView.commentDelegate = newValue
    }
  }
    
  weak var textViewDelegate: UITextViewDelegate? {
    get {
      commentInputView.textViewDelegate
    } set {
      commentInputView.textViewDelegate = newValue
    }
  }
  
  var textLineheight: CGFloat {
    commentInputView.lineHeight
  }
  
  // MARK: - Lifecycle
  init() {
    super.init(
      frame: .zero,
      contentView: commentInputView,
      contentViewSpacing: .init(top: 0, left: 10, bottom: 0, right: 0),
      profileLayoutInfo: .medium(.bottom))
  }
  
  required init?(coder: NSCoder) {
    nil
  }
}

// MARK: - Helpers
extension PostProfileAndCommentView {
  func activeScrollableContent() {
    commentInputView.activeScrollableContent()
  }
  
  func deactiveScrollableContent() {
    commentInputView.deactiveScrollableContent()
  }
}

// MARK: - UITextViewDelegate
/// 외부에서 textViewDelegate를 채택하면 이함수를 호출해야 합니다.
extension PostProfileAndCommentView {
  func textViewDidBeginEditing(_ textView: UITextView) {
    commentInputView.textViewDidBeginEditing(textView)
  }
  
  func textViewDidChange(_ textView: UITextView) {
    commentInputView.textViewDidChange(textView)
  }
  
  func textViewDidEndEditing(_ textView: UITextView) {
    commentInputView.textViewDidEndEditing(textView)
  }
}

