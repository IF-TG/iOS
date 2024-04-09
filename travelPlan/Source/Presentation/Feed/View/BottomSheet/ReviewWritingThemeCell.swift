//
//  ReviewWritingThemeCell.swift
//  travelPlan
//
//  Created by 양승현 on 4/9/24.
//

import UIKit

protocol ReviewWritingThemeCellDelegate: AnyObject {
  func reviewWritingThemeCell(_ cell: ReviewWritingThemeCell?, isSelected: Bool)
}

final class ReviewWritingThemeCell: UICollectionViewCell {
  static let id = String(describing: ReviewWritingThemeCell.self)
  
  // MARK: - Properties
  private let themeMenu = PrimaryColorToneRoundButton(currentState: .normal)
  
  weak var delegate: ReviewWritingThemeCellDelegate?
  
  private var isEnableMultiSelection: Bool = false
  
  // MARK: - Lifecycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
    themeMenu.tapHandler = { [weak self] in
      guard
        let prevSelectionState = self?.themeMenu.currentState,
        let isEnableMultiSelection = self?.isEnableMultiSelection
      else { return }
      
      if isEnableMultiSelection {
        let isSelected = prevSelectionState == .selected
        self?.themeMenu.currentState = isSelected ? .normal : .selected
      } else {
        if prevSelectionState == .normal {
          self?.activeSelection()
        } else {
          self?.deactiveSelection()
        }
      }
      guard let currentState = self?.themeMenu.currentState else { return }
      self?.delegate?.reviewWritingThemeCell(self, isSelected: currentState == .selected)
    }
    
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    configure(themeText: nil, isSelected: false, isEnableMultiSelection: false)
  }
  
  // MARK: - Helpers
  func configure(themeText: String?, isSelected: Bool, isEnableMultiSelection: Bool) {
    self.isEnableMultiSelection = isEnableMultiSelection
    guard let themeText else {
      themeMenu.setTitle(nil, for: .normal)
      themeMenu.currentState = .normal
      return
    }
    themeMenu.setTitle(themeText, for: .normal)
    themeMenu.currentState = isSelected ? .selected : .normal
  }
  
  func activeSelection() {
    themeMenu.currentState = .normal
    themeMenu.isUserInteractionEnabled = true
  }
  
  func deactiveSelection() {
    themeMenu.currentState = .selected
    themeMenu.isUserInteractionEnabled = false
  }
}

// MARK: - LayoutSupport
extension ReviewWritingThemeCell: LayoutSupport {
  func addSubviews() {
    contentView.addSubview(themeMenu)
  }
  
  func setConstraints() {
    NSLayoutConstraint.activate([
      themeMenu.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      themeMenu.topAnchor.constraint(equalTo: contentView.topAnchor),
      themeMenu.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      themeMenu.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)])
  }
}
