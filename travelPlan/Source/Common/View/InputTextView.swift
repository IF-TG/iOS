//
//  InputTextView.swift
//  travelPlan
//
//  Created by 양승현 on 11/11/23.
//

import UIKit

class InputTextView: UITextView {
  // MARK: - Properties
  public var placeholder = BaseLabel(fontType: .medium_500(fontSize: 15)).set {
    $0.textColor = .yg.gray1
    $0.text = "텍스트를 입력해주세요."
  }
  
  public var isPlaceholderHiddenWhenTextBeginEditing: Bool = false
  
  private let placeholderInfo: PlaceholderInfo
  
  private var placeholderText: String? {
    didSet {
      placeholder.text = placeholderText
    }
  }
  
  var length: Int {
    text.count
  }
  
  // MARK: - Lifecycle
  init(
    frame: CGRect,
    textContainer: NSTextContainer?,
    placeholderInfo: PlaceholderInfo
  ) {
    self.placeholderInfo = placeholderInfo
    self.placeholderText = placeholderInfo.placeholderText
    super.init(frame: frame, textContainer: textContainer)
    baseConfigureUI()
  }
  
  convenience init(textContainer: NSTextContainer?, placeholderInfo: PlaceholderInfo = .init()) {
    self.init(frame: .zero, textContainer: textContainer, placeholderInfo: placeholderInfo)
    translatesAutoresizingMaskIntoConstraints = false
  }
  
  convenience init(placeholderInfo: PlaceholderInfo) {
    self.init(frame: .zero, textContainer: nil, placeholderInfo: placeholderInfo)
    translatesAutoresizingMaskIntoConstraints = false
  }
  
  convenience init() {
    self.init(frame: .zero, textContainer: nil, placeholderInfo: .init())
    translatesAutoresizingMaskIntoConstraints = false
  }
  
  required init?(coder: NSCoder) {
    nil
  }
  // MARK: - Helpers
  
  // MARK: - Private Helpers
  func baseConfigureUI() {
    setPlaceholderLayout()
    delegate = self
  }
}

// MARK: - LayoutSupport
private extension InputTextView {
  func setPlaceholderLayout() {
    addSubview(placeholder)
    NSLayoutConstraint.activate(placeholderConsriants)
  }
  
  var placeholderConsriants: [NSLayoutConstraint] {
    let inset = placeholderInfo.inset
    let position = placeholderInfo.position
    let constraints = [
      placeholder.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset.left),
      placeholder.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -inset.right)]
    switch position {
    case .top:
      return constraints + [placeholder.topAnchor.constraint(equalTo: topAnchor, constant: inset.top)]
    case .centerY:
      return constraints + [placeholder.centerYAnchor.constraint(equalTo: centerYAnchor)]
    }
  }
}

// MARK: - UITextViewDelegate
extension InputTextView: UITextViewDelegate {
  func textViewDidChange(_ textView: UITextView) {
    guard let text = textView.text else { return }
    placeholder.isHidden = text.isEmpty ? false : true
  }
  
  func textViewDidBeginEditing(_ textView: UITextView) {
    if isPlaceholderHiddenWhenTextBeginEditing {
      placeholder.isHidden = true
    }
  }
  
  func textViewDidEndEditing(_ textView: UITextView) {
    if textView.text == nil || length < 1 {
      placeholder.isHidden = false
    }
  }
}

// MARK: - Utils
extension InputTextView {
  struct PlaceholderInfo {
    let placeholderText: String?
    let position: Position
    let inset: UIEdgeInsets
    
    init(placeholderText: String? = nil, position: Position = .centerY, inset: UIEdgeInsets = .zero) {
      self.placeholderText = placeholderText
      self.position = position
      self.inset = inset
    }
    
    enum Position {
      case top
      case centerY
    }
  }
}
