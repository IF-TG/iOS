//
//  NSMutableAttributedString+.swift
//  travelPlan
//
//  Created by 양승현 on 11/2/23.
//

import UIKit

struct HighlightFontInfo {
  let fontType: UIFont.Pretendard
  var lineHeight: CGFloat?
  let text: String
  
  /// 색이나 kern(자간간격) 등 추가적인 attributes!!.
  var additionalAttributes: [NSAttributedString.Key: Any]?
  var startIndex: Int?
}

extension NSMutableAttributedString {
  /// 기본적으로 UIFOnt.Pretendard 타입과 Optional(lineHeight)를 지정할 경우 모든 텍스트에 앞에 언급한 attributes를 적용합니다.
  func setPretendard(with fontType: UIFont.Pretendard, lineHeight: CGFloat? = nil) {
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
   기존 텍스트의 attributes설정 후, 기존 택스트에서 특정한 문자열만 highlight해야하는 경우입니다.
  
   Notes:
   1. base keyword: 기본적으로 적용될 Pretendard 타입
   2. highlightInfo keyword: 특정 문구에 적용될 Pretendard 타입
  */
  func setPretendard(
    baseType: UIFont.Pretendard,
    baseLineHeight: CGFloat? = nil,
    highlightInfo info: HighlightFontInfo
  ) {
    setPretendard(with: baseType, lineHeight: baseLineHeight)
    
    setHighlightedPretendard(with: info)
  }
  
  /// 기존에 존재하는 택스트에서 서로 다른 여러 문구에서 각각의 문자열들을 highlight할 경우 사용하면 됩니다.
  func setPretendard(
    baseType: UIFont.Pretendard,
    baseLineHeight: CGFloat? = nil,
    otherTypes: HighlightFontInfo...
  ) {
    setPretendard(with: baseType, lineHeight: baseLineHeight)
    
    otherTypes.forEach {
      setHighlightedPretendard(with: $0)
    }
  }
  
  /// 기존에 존재하는 텍스트에서 특정한 문구의 텍스트만 highlight해야하는 경우에 호출하면 됩니다.
  /// 주의사항: 위치를 지정하지 않을경우 prefix에 위치하는 문구만 계속해서 새로운 attributes로 적용될 수 있습니다.
  func setHighlightedPretendard(with highlightInfo: HighlightFontInfo) {
    var highlightAttributes = convertToNSAttributes(
      from: highlightInfo.fontType,
      lineHeight: highlightInfo.lineHeight)
    if let additionalAttributes = highlightInfo.additionalAttributes {
      additionalAttributes.forEach {
        highlightAttributes[$0] = $1
      }
    }
    if let startIndex = highlightInfo.startIndex {
      addAttributes(highlightAttributes, range: NSRange(location: startIndex, length: highlightInfo.text.count))
    } else {
      addAttributes(highlightAttributes, range: (string as NSString).range(of: highlightInfo.text))
    }
  }
}
