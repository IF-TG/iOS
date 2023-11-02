//
//  UIFont+.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/13.
//

import UIKit

extension UIFont {
  /// YG app에서 사용되는 Pretendard Font
  /// Example:
  /// ```
  /// Example:
  /// let lb = UILabel()
  /// lb.font = UIFont(pretendard: .semiBold, size: 18)!
  /// ```
  enum Pretendard {
    /// 400
    case regular_400(lineHeight: CGFloat)
    /// 500
    case medium_500(lineHeight: CGFloat)
    /// 600
    case semiBold_600(lineHeight: CGFloat)
    /// 700
    case bold_700(lineHeight: CGFloat)
    
    var path: String {
      switch self {
      case .regular_400:
        return "Pretendard-Regular"
      case .medium_500:
        return "Pretendard-Medium"
      case .semiBold_600:
        return "Pretendard-SemiBold"
      case .bold_700:
        return "Pretendard-Light"
      }
    }
    
    var lineHeight: CGFloat {
      switch self {
      case .regular_400(lineHeight: let height):
        return height
      case .medium_500(lineHeight: let height):
        return height
      case .semiBold_600(lineHeight: let height):
        return height
      case .bold_700(lineHeight: let height):
        return height
      }
    }
  }
  
  convenience init?(pretendard: Pretendard, size: CGFloat) {
    self.init(name: pretendard.path, size: size)
  }
}
