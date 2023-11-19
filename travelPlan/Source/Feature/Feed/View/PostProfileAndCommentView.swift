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
  
  weak var inputDelegate: CommentInputViewDelegate? {
    get {
      return commentInputView.delegate
    } set {
      commentInputView.delegate = newValue
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
  
  func showKeyboard() {
    commentInputView.showKeyboard()
  }
  
  func hideKeyboard() {
    commentInputView.hideKeyboard()
  }
  
  func setScrollEnabled(_ value: Bool) {
    commentInputView.setScrollEnabled(value)
  }
}
