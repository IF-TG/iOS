//
//  IconWithLabelStackView.swift
//  travelPlan
//
//  Created by 양승현 on 11/13/23.
//

import UIKit

class IconWithLabelStackView: UIStackView {
  public let icon: UIImageView
  
  public let label: BaseLabel
  
  init(frame: CGRect, iconInfo: IconInfo, countInfo: CountLabelInfo) {
    icon = UIImageView(image: UIImage(named: iconInfo.iconPath)).set {
      $0.contentMode = .scaleToFill
    }
    label = BaseLabel(fontType: countInfo.fontType, lineHeight: countInfo.lineHeight)
    super.init(frame: frame)
    configureUI()
    
    icon.widthAnchor.constraint(equalToConstant: iconInfo.size.width).isActive = true
    icon.heightAnchor.constraint(equalToConstant: iconInfo.size.height).isActive = true
  }
  
  convenience init(
    iconInfo: IconInfo,
    countInfo: CountLabelInfo
  ) {
    self.init(frame: .zero, iconInfo: iconInfo, countInfo: countInfo)
    translatesAutoresizingMaskIntoConstraints = false
  }
  
  required init(coder: NSCoder) {
    fatalError()
  }
}

// MARK: - Helpers
extension IconWithLabelStackView {
  func setCountLabel(text: String?) {
    label.text = text
  }
}

// MARK: - Private Helpers
extension IconWithLabelStackView {
  private func configureUI() {
    addArrangedSubview(icon)
    addArrangedSubview(label)
    axis = .horizontal
    spacing = 5
    distribution = .equalSpacing
    alignment = .center
  }
}

// MARK: - Utils
extension IconWithLabelStackView {
  struct IconInfo {
    let size: CGSize
    let iconPath: String
  }
  
  struct CountLabelInfo {
    let fontType: UIFont.Pretendard
    let lineHeight: CGFloat?
  }
}
