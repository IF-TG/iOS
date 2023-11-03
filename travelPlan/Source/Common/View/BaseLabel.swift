//
//  BaseLabel.swift
//  travelPlan
//
//  Created by 양승현 on 11/2/23.
//

import UIKit

class BaseLabel: UILabel {
  // MARK: - Properties
  private var fontType: UIFont.Pretendard
  
  private var lineHeight: CGFloat?
  
  override var text: String? {
    didSet {
      setPretendardFont()
    }
  }
  
  override var intrinsicContentSize: CGSize {
    var size = super.intrinsicContentSize
    if let lineHeight {
      let numberOfLines = max(1, Int(size.height / lineHeight))
      size.height = lineHeight * CGFloat(numberOfLines)
    }
    return size
  }
  
  // MARK: - Lifecycle
  init(frame: CGRect, fontType: UIFont.Pretendard, lineHeight: CGFloat? = nil) {
    self.lineHeight = lineHeight
    self.fontType = fontType
    super.init(frame: frame)
  }
  
  convenience init(fontType: UIFont.Pretendard, lineHeight: CGFloat? = nil) {
    self.init(frame: .zero, fontType: fontType, lineHeight: lineHeight)
    translatesAutoresizingMaskIntoConstraints = false
  }
  
  required init?(coder: NSCoder) {
    nil
  }
}

// MARK: - Helpers
extension BaseLabel {
  /// 강조를하기전에 기본적으로 text에 텍스트가 있어야 합니다.
  func setHighlight(with info: HighlightFontInfo) {
    guard let text else { return }
    attributedText = NSMutableAttributedString(string: text).set {
      $0.setHighlightedPretendard(with: info)
    }
  }
  
  func setHighlights(with list: HighlightFontInfo...) {
    guard let attributedText else { return }
    self.attributedText = NSMutableAttributedString(attributedString: attributedText).set { mutableString in
      list.forEach {
        mutableString.setHighlightedPretendard(with: $0)
      }
    }
  }
}

// MARK: - Private Helpers
private extension BaseLabel {
  func setPretendardFont() {
    guard let attributedText else { return }
    self.attributedText = NSMutableAttributedString(attributedString: attributedText).set {
      $0.setPretendard(with: fontType, lineHeight: lineHeight)
    }
  }
}
