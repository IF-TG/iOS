//
//  WrappedPaddingButton.swift
//  travelPlan
//
//  Created by 양승현 on 5/31/24.
//

import UIKit

/// UIView내부에 padding을 적용한 뷰가 있습니다.
///
/// init시점에 버튼의 속성을 설정하거나, configure로 버튼의 속성을 설정합니다.
/// ```
/// let button: UIButton
/// let image = UIImage(named: "이미지")
/// if #available(iOS 15.0, *) {
///   var config = UIButton.Configuration.plain()
///   config.contentInsets = NSDirectionalEdgeInsets(top: 7, leading: 7, bottom: 7, trailing: 7)
///   config.image = image
///   config.imagePlacement = .all
///   button = UIButton(configuration: config)
///   } else {
///   button = UIButton(frame: .zero)
///   button.imageEdgeInsets = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
///   button.setImage(image?.setColor(.yg.gray4), for: .normal)
///   button.setImage(image?.setColor(.yg.gray4.withAlphaComponent(0.5)), for: .highlighted)
///   }
///   ...
/// ```
/// 위 코드에서 configuration을 통해서 contentInsets의 padding을 주입해도, 이미지에 패딩이 적용되지 않았습니다. 여러 방법을 사용해도
/// configuration에서 버튼의 이미지에 패딩을 줄 수 있는 방법을 찾지 못해 이렇게 뷰를 감싼 객체를 만들었습니다.
final class WrappedPaddingButton: UIView {
  private var padding: UIEdgeInsets
  
  private let button: UIButton = UIButton()
  
  init(frame: CGRect, padding: UIEdgeInsets, config: (UIButton) -> Void) {
    self.padding = padding
    super.init(frame: frame)
    button.translatesAutoresizingMaskIntoConstraints = false
    config(button)
    setupUI()
  }
  convenience init(padding: UIEdgeInsets, config: (UIButton) -> Void) {
    self.init(frame: .zero, padding: padding, config: config)
    translatesAutoresizingMaskIntoConstraints = false
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Public Helpers
extension WrappedPaddingButton {
  func configure(_ config: (UIButton) -> Void) {
    config(button)
  }
  
  func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControl.Event) {
    button.addTarget(target, action: action, for: controlEvents)
  }
}

// MARK: - LayoutSupport
extension WrappedPaddingButton: LayoutSupport {
  func addSubviews() {
    addSubview(button)
  }
  
  func setConstraints() {
    NSLayoutConstraint.activate([
      button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding.left),
      button.topAnchor.constraint(equalTo: topAnchor, constant: padding.top),
      button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding.bottom),
      button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding.right)])
  }
}
