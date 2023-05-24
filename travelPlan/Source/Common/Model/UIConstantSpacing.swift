//
//  UIConstantSpacing.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/20.
//

import Foundation

/// UI Constant spacing 정할 때 CGFloat를 쉽게 선언하기 위한 구조체
/// # Example #
/// ```
/// extension FavoriteListTableViewCell {
///   enum Constant {
///     enum ImageView {
///       static let spacing = UIConstantSpacing(top: 0, leading: 20, trailing: -10, bottom: -10)
///       static let size: CGSize = ....
///     }
///     enum Title {
///       static let spacing = UIConstantSpacing(leading: 20)
///     }
///   }
/// }
/// ```
struct UIConstantSpacing {
  let top: CGFloat
  let leading: CGFloat
  let trailing: CGFloat
  let bottom: CGFloat
  
  init(
    leading: CGFloat = 0,
    top: CGFloat = 0,
    trailing: CGFloat = 0,
    bottom: CGFloat = 0
  ) {
    self.top = top
    self.leading = leading
    self.trailing = trailing
    self.bottom = bottom
  }
}
