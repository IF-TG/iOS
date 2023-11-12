//
//  IconWithCountLabelStackView.swift
//  travelPlan
//
//  Created by 양승현 on 11/13/23.
//

import UIKit

class IconWithCountLabelStackView: UIStackView {
  public let icon: UIImageView
  
  public let countLabel: BaseLabel
  
  init(frame: CGRect, iconInfo: IconInfo, countInfo: CountLabelInfo) {
    icon = UIImageView(image: UIImage(named: iconInfo.iconPath)).set {
      $0.contentMode = .scaleToFill
    }
    countLabel = BaseLabel(fontType: countInfo.fontType, lineHeight: countInfo.lineHeight)
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
extension IconWithCountLabelStackView {
  func setCountLabel(text: String?) {
    countLabel.text = text
  }
}

// MARK: - Private Helpers
extension IconWithCountLabelStackView {
  private func configureUI() {
    addArrangedSubview(icon)
    addArrangedSubview(countLabel)
    axis = .horizontal
    spacing = 5
    distribution = .equalSpacing
    alignment = .leading
  }
}

// MARK: - Utils
extension IconWithCountLabelStackView {
  struct IconInfo {
    let size: CGSize
    let iconPath: String
  }
  
  struct CountLabelInfo {
    let fontType: UIFont.Pretendard
    let lineHeight: CGFloat?
  }
}
