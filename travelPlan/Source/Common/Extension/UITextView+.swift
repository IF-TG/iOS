//
//  UITextView+.swift
//  travelPlan
//
//  Created by 양승현 on 11/15/23.
//

import UIKit

extension UITextView {
  func setDraggingGestureToCopyInClipboard() {
    isUserInteractionEnabled = true
    isEditable = false
    let gesture = UIPanGestureRecognizer(
      target: self,
      action: #selector(handleDragging))
    addGestureRecognizer(gesture)
  }
  
  @objc private func handleDragging(_ gesture: UIPanGestureRecognizer) {
    if gesture.state == .ended {
      guard let selectedText else { return }
      UIPasteboard.general.string = selectedText
    }
  }
  
  var selectedText: String? {
    guard let range = selectedTextRange else { return nil }
    return text(in: range)
  }
}

