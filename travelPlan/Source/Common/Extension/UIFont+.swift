//
//  UIFont+.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/13.
//

import UIKit

extension UIFont {
  /// YG app에서 사용되는 Pretendard Font
  /// # Example #
  /// ```
  /// Example:
  /// let lb = UILabel()
  /// lb.font = UIFont(pretendard: .semiBold, size: 18)!
  /// ```
  enum Pretendard {
    /// 400
    case regular
    /// 500
    case medium
    /// 600
    case semiBold
    /// 700
    case bold
    case black
    case extraBold
    case extraLight
    case light
    case thin
    var toString: String {
      switch self {
      case .black:
        return "Pretendard-Black"
      case .bold:
        return "Pretendard-Bold"
      case .extraBold:
        return "Pretendard-ExtraBold"
      case .extraLight:
        return "Pretendard-ExtraLight"
      case .light:
        return "Pretendard-Light"
      case .medium:
        return "Pretendard-Medium"
      case .regular:
        return "Pretendard-Regular"
      case .semiBold:
        return "Pretendard-SemiBold"
      case .thin:
        return "Pretendard-Thin"
      }
    }
  }
  
  convenience init?(pretendard: Pretendard, size: CGFloat) {
    self.init(name: pretendard.toString, size: size)
  }
}
