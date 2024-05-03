//
//  ColorStyles+UIColor.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/11.
//

import UIKit

extension UIColor {
  typealias yg = YeoGa
  typealias YG = YeoGa
  /// YG app에서 사용되는 palette
  /// Example:
  /// ```
  /// Example:
  ///
  /// view.backgroundColor = .yg.gray0
  /// view.backgroundColor = .YG.gray0
  /// view.backgroundColor = UIColor.yg.gray0
  /// ```
  enum YeoGa {
    // MARK: - Gray
    /// #F9F9F9
    static let gray00Background = UIColor(named: "gray0Background")!
    
    /// #F2F0F0
    static let veryLightGray = UIColor(named: "gray0VeryLight")!
    
    /// #D9D9D9
    static let gray0 = UIColor(named: "gray0")!
    
    /// #C9C9C9
    static let gray1 = UIColor(named: "gray1")!
    
    /// #B4B4B4
    static let gray2 = UIColor(named: "gray2")!
      
    /// #717171
    static let gray3 = UIColor(named: "gray3")!
    
    /// #676767
    static let gray4 = UIColor(named: "gray4")!
    
    /// #484848
    static let gray5 = UIColor(named: "gray5")!
    
    /// #4B4B4B
    static let gray6 = UIColor(named: "gray6")!
    
    /// #333333
    static let gray7 = UIColor(named: "gray7")!
    
    // MARK: - brand color
    /// #1BA0EB
    static let primary = UIColor(named: "primary")!
    
    /// #FE0135
    static let red = UIColor(named: "yeogaRed")!
    
    /// #EE0031
    static let red2 = UIColor(named: "yeogaRed2")!
    
    /// #0072C6
    static let highlight = UIColor(named: "highlight")!
                              
    /// #FBFBFB
    static let littleWhite = UIColor(named: "littleWhite")!
    
    /// #FEE500
    static let kakao = UIColor(named: "kakaoPrimary")!
  }
}
