//
//  InputTextView.swift
//  travelPlan
//
//  Created by 양승현 on 11/11/23.
//

import UIKit

class InputTextView: UITextView {
  // MARK: - Properties
  public var placeholder = BaseLabel(fontType: .medium_500(fontSize: 14)).set {
    $0.textColor = .yg.gray1
    $0.text = "텍스트를 입력해주세요."
  }
  
  public var isPlaceholderHiddenWhenTextBeginEditing: Bool = false
  
  private let placeholderInfo: PlaceholderInfo
  
  override var text: String! {
    didSet {
      placeholder.isHidden = !text.isEmpty
      invalidateIntrinsicContentSize()
    }
  }
  
  override var font: UIFont? {
    didSet {
      placeholder.font = font
      invalidateIntrinsicContentSize()
    }
  }
  
  var maxHeight: CGFloat = 0
  
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
    placeholder.text = placeholderInfo.placeholderText
    super.init(frame: frame, textContainer: textContainer)
    baseConfigureUI()
    setTextDidChangedNotification()
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
  
  override var intrinsicContentSize: CGSize {
    var size = super.intrinsicContentSize
    if size.height == UIView.noIntrinsicMetric {
      layoutManager.glyphRange(for: textContainer)
      size.height = layoutManager.usedRect(for: textContainer)
        .height + textContainerInset.top + textContainerInset.bottom
    }
    
    if size.height > maxHeight {
      size.height = maxHeight
      if !isScrollEnabled { isScrollEnabled.toggle() }
    } else if isScrollEnabled {
      isScrollEnabled.toggle()
    }
    return size
  }
}

// MARK: - Private Helpers
extension InputTextView {
  private func baseConfigureUI() {
    setPlaceholderLayout()
    isScrollEnabled = false
  }
  
  private func setTextDidChangedNotification() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(UITextInputDelegate.textDidChange(_:)),
      name: UITextView.textDidChangeNotification,
      object: self)
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
extension InputTextView {
  @objc private func textDidChange(_ note: Notification) {
    placeholder.isHidden = !text.isEmpty
    invalidateIntrinsicContentSize()
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
