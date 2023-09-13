//
//  CoreTextSizeCalculator.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/08/28.
//

import Foundation
import CoreText

/// UI에 의존하지 않고, text의 size(width, height)를 계산합니다.
struct CoreTextSizeCalculator {
  /// text의 size 결정 요소는 (문자열 길이 + 폰트 크기 + 폰트 종류) 3가지에 의해 결정됩니다.
  static func textSize(
    _ text: String,
    fontSize: CGFloat,
    fontName: String
  ) -> CGSize {
    // 폰트 생성
    let font = CTFontCreateWithName(text as CFString, fontSize, nil)
    
    // 속성 문자열 생성
    let attributes: [NSAttributedString.Key: Any] = [.font: font]
    let attributedString = NSAttributedString(string: text, attributes: attributes)
    
    // 문자열 size
    return attributedString
      .boundingRect(
        with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude),
        options: [.usesLineFragmentOrigin, .usesFontLeading],
        context: nil
      )
      .size
  }
}
