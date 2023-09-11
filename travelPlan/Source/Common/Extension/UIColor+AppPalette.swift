//
//  ColorStyles+UIColor.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/11.
//

import UIKit

extension UIColor {
  typealias yg = YG
  /// YG app에서 사용되는 palette
  /// # Example #
  /// ```
  /// Example:
  ///
  /// view.backgroundColor = .yg.gray0
  /// view.backgroundColor = .YG.gray0
  /// view.backgroundColor = UIColor.yg.gray0
  /// ```
  enum YG {
    // MARK: - Gray
    /// #F9F9F9
    static let gray00Background = UIColor(
      red: 0.975, green: 0.975, blue: 0.975, alpha: 1)
    /// #F2F0F0
    static let veryLightGray = UIColor(
      red: 0.949, green: 0.941, blue: 0.941, alpha: 1)
    /// #D9D9D9
    static let gray0 = UIColor(
      red: 0.851, green: 0.851, blue: 0.851, alpha: 1)
    /// #C9C9C9
    static let gray1 = UIColor(
      red: 0.788, green: 0.788, blue: 0.788, alpha: 1)
    /// #B4B4B4
    static let gray2 = UIColor(
      red: 0.704, green: 0.704, blue: 0.704, alpha: 1)
    /// #717171
    static let gray3 = UIColor(
      red: 0.443, green: 0.443, blue: 0.443, alpha: 1)
    /// #676767
    static let gray4 = UIColor(
      red: 0.404, green: 0.404, blue: 0.404, alpha: 1)
    /// #484848
    static let gray5 = UIColor(
      red: 0.283, green: 0.283, blue: 0.283, alpha: 1)
    /// #4B4B4B
    static let gray6 = UIColor(
      red: 0.294, green: 0.294, blue: 0.294, alpha: 1)
    /// #333333
    static let gray7 = UIColor(
      red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
    
    // MARK: - brand color
    /// #1BA0EB
    static let primary = UIColor(
      red: 0.106, green: 0.627, blue: 0.922, alpha: 1)
    /// #FE0135
    static let red = UIColor(
      red: 0.996, green: 0.004, blue: 0.208, alpha: 1)
    /// #EE0031
    static let red2 = UIColor(
      red: 0.933, green: 0, blue: 0.192, alpha: 1)
    /// #0072C6
    static let highlight = UIColor(hex: "0072C6", alpha: 1)
    /// #FBFBFB
    static let littleWhite = UIColor(hex: "#FBFBFB", alpha: 1)
  }
}
