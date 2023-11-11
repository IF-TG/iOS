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
      commentInputView.delegate
    } set {
      commentInputView.delegate = newValue
    }
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
