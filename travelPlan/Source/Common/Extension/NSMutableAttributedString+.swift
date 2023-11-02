//
//  NSMutableAttributedString+.swift
//  travelPlan
//
//  Created by 양승현 on 11/2/23.
//

import UIKit

extension NSMutableAttributedString {
  /// 기본적으로 UIFOnt.Pretendard 타입과 Optional(lineHeight)를 지정할 경우 모든 텍스트에 앞에 언급한 attributes를 적용합니다.
  func setPretendard(with fontType: UIFont.Pretendard, lineHeight: CGFloat? = nil) {
    let font = fontType.uiFont
    let attributes = convertToNSAttributes(from: fontType, lineHeight: lineHeight)
    
    addAttributes(
      attributes,
      range: NSRange(location: 0, length: string.count))
  }
  
  /// UIFont.Pretendard로부터 NSAttributedString의 attributes를 반환합니다.
  private func convertToNSAttributes(
    from fontType: UIFont.Pretendard,
    lineHeight: CGFloat? = nil
  ) -> [NSAttributedString.Key: Any] {
    guard let font = fontType.uiFont else { return [:] }
    var attributes = [.font: font] as [NSAttributedString.Key: Any]
    
    if let lineHeight {
      let style = NSMutableParagraphStyle().set {
        $0.minimumLineHeight = lineHeight
        $0.maximumLineHeight = lineHeight
      }
      attributes[.paragraphStyle] = style
      attributes[.baselineOffset] = (lineHeight - font.lineHeight) / 4
    }
    return attributes
  }
  
  /**
   기본 글자에 다른 타입의 highlight text를 적용할 떄 사용하면 편합니다.
  
   Notes:
   1. base keyword: 기본적으로 적용될 Pretendard 타입
   2. other keyword: 특정 문구에 적용될 Pretendard 타입
  */
  func setPretendard(
    baseType: UIFont.Pretendard,
    baseLineLeight: CGFloat? = nil,
    otherType: UIFont.Pretendard,
    otherLineHeight: CGFloat? = nil,
    otherText: String
  ) {
    setPretendard(with: baseType, lineHeight: baseLineLeight)
    
    guard let otherFont = otherType.uiFont else { return }
    let otherAttributes = convertToNSAttributes(from: otherType, lineHeight: otherLineHeight)
    
    addAttributes(otherAttributes, range: (string as NSString).range(of: otherText))
  }
}
