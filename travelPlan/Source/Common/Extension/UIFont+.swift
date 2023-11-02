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
  /// lb.font = UIFont(pretendard: .semiBold_600(fontSize: 14)!
  /// ```
  enum Pretendard {
    /// 400
    case regular_400(fontSize: CGFloat)
    /// 500
    case medium_500(fontSize: CGFloat)
    /// 600
    case semiBold_600(fontSize: CGFloat)
    /// 700
    case bold_700(fontSize: CGFloat)
    
    var path: String {
      switch self {
      case .regular_400:
        return "Pretendard-Regular"
      case .medium_500:
        return "Pretendard-Medium"
      case .semiBold_600:
        return "Pretendard-SemiBold"
      case .bold_700:
        return "Pretendard-Bold"
      }
    }
    
    var size: CGFloat {
      switch self {
      case .regular_400(fontSize: let size):
        return size
      case .medium_500(fontSize: let size):
        return size
      case .semiBold_600(fontSize: let size):
        return size
      case .bold_700(fontSize: let size):
        return size
      }
    }
    
    var uiFont: UIFont? {
      UIFont(pretendard: self)
    }
  }
}

extension UIFont {
  convenience init?(pretendard font: Pretendard) {
    self.init(name: font.path, size: font.size)
  }
}
