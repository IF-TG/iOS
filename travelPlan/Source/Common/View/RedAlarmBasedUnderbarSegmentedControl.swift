//
//  RedAlarmBasedUnderbarSegmentedControl.swift
//  travelPlan
//
//  Created by 양승현 on 10/28/23.
//

import UIKit

struct UnderbarInfo {
  var height: CGFloat
  var backgroundColor: UIColor
}

class RedAlarmBasedUnderbarSegmentedControl: UISegmentedControl {
  // MARK: - Properties
  private lazy var underbar = UIView(frame: .zero).set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = underbarInfo.backgroundColor
    addSubview($0)
    NSLayoutConstraint.activate([
      $0.leadingAnchor.constraint(equalTo: leadingAnchor),
      $0.bottomAnchor.constraint(equalTo: bottomAnchor),
      $0.widthAnchor.constraint(equalToConstant: underbarWidth ?? 50),
      $0.heightAnchor.constraint(equalToConstant: underbarInfo.height)])
  }
  
  private lazy var underbarWidth: CGFloat? = bounds.size.width / CGFloat(numberOfSegments)
  
  private var underbarInfo: UnderbarInfo
  
  private var isFirstSettingDone = false
  
  // MARK: - Lifecycle
  init(frame: CGRect, underbarInfo info: UnderbarInfo) {
    self.underbarInfo = info
    super.init(frame: frame)
    configureUI()
  }
  
  init(items: [Any]?, underbarInfo info: UnderbarInfo) {
    self.underbarInfo = info
    super.init(items: items)
    configureUI()
    selectedSegmentIndex = 0
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    if isFirstSettingDone {
      isFirstSettingDone.toggle()
      layer.cornerRadius = 0
    }
    let underBarLeadingSpacing = CGFloat(selectedSegmentIndex) * (underbarWidth ?? 50)
    UIView.animate(withDuration: 0.27, delay: 0, options: .curveEaseOut, animations: {
      self.underbar.transform = .init(translationX: underBarLeadingSpacing, y: 0)
    })
  }
}

// MARK: - Private Helpers
private extension RedAlarmBasedUnderbarSegmentedControl {
  func configureUI() {
    removeBorders()
    setTitleTextAttributes([.foregroundColor: underbarInfo.backgroundColor], for: .selected)
    if #available(iOS 13.0, *) {
      selectedSegmentTintColor = .clear
    } else {
      tintColor = .clear
    }
  }
  
  func makeUnderbar(height: CGFloat) -> UIView {
    return .init(frame: .zero).set {
      $0.translatesAutoresizingMaskIntoConstraints = false
    }
  }
  
  func removeBorders() {
    let image = UIImage()
    setBackgroundImage(image, for: .normal, barMetrics: .default)
    setBackgroundImage(image, for: .selected, barMetrics: .default)
    setBackgroundImage(image, for: .highlighted, barMetrics: .default)
    setDividerImage(image, forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
  }
}
