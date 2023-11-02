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
    case regular_400
    /// 500
    case medium_500
    /// 600
    case semiBold_600
    /// 700
    case bold_700
    
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
  }
  
  convenience init?(pretendard: Pretendard, size: CGFloat) {
    self.init(name: pretendard.path, size: size)
  }
}
