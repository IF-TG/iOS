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
    case black
    case bold
    case extraBold
    case extraLight
    case light
    case medium
    case regular
    case semiBold
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

/// # Example #
/// ```
/// Example:
/// let lb = UILabel()
/// lb.font = UIFont(SFPro: .semiBold, size: 18)!
/// ```
extension UIFont {
  enum SFPro {
    case italic
    case semiBold
    case sfPro
    
    var toStr: String {
      switch self {
      case .italic: return "SFPro-Italic"
      case .semiBold: return "SFProText-Semibold"
      case .sfPro: return "SFPro"
      }
    }
  }
  convenience init?(SFPro: SFPro, size: CGFloat) {
    self.init(name: SFPro.toStr, size: size)
  }
}
