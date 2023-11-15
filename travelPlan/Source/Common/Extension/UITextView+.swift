//
//  UITextView+.swift
//  travelPlan
//
//  Created by 양승현 on 11/15/23.
//

import UIKit

// MARK: - Append text in Clip board Helpers
extension UITextView {
  func setTapGestureForDraggingToCopyInClipboard() {
    isUserInteractionEnabled = true
    isEditable = false
    let gesture = UIPanGestureRecognizer(
      target: self,
      action: #selector(handleTapGestureDragging))
    addGestureRecognizer(gesture)
  }
  
  func setLongGestureForDraggingToCopyInClipboard() {
    isUserInteractionEnabled = true
    isEditable = false
    let gesture = UILongPressGestureRecognizer(
      target: self,
      action: #selector(handleLongGestureDragging))
    addGestureRecognizer(gesture)
  }
}

// MARK: - Append text in clip board Actions
extension UITextView {
  @objc private func handleTapGestureDragging(_ gesture: UIPanGestureRecognizer) {
    if gesture.state == .ended {
      guard let selectedText else { return }
      UIPasteboard.general.string = selectedText
    }
  }
  
  @objc private func handleLongGestureDragging(_ gesture: UILongPressGestureRecognizer) {
    guard gesture.state == .ended, let range = selectedTextRange, let text = text(in: range) else { return }
    UIPasteboard.general.string = text
  }

}

// MARK: - Heleprs
extension UITextView {
  var selectedText: String? {
    guard let range = selectedTextRange else { return nil }
    return text(in: range)
  }
}
