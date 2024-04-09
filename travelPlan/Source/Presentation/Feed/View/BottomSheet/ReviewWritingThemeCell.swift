//
//  ReviewWritingThemeCell.swift
//  travelPlan
//
//  Created by 양승현 on 4/9/24.
//

import UIKit

protocol ReviewWritingThemeCellDelegate: AnyObject {
  func reviewWritingThemeCell(_ cell: UICollectionViewCell?, isSelected: Bool)
}

final class ReviewWritingThemeCell: UICollectionViewCell {
  static let id = String(describing: ReviewWritingThemeCell.self)
  
  // MARK: - Properties
  private let themeMenu = PrimaryColorToneRoundButton(currentState: .normal)
  
  weak var delegate: ReviewWritingThemeCellDelegate?
  
  // MARK: - Lifecycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
    themeMenu.tapHandler = { [weak self] in
      guard let currentState = self?.themeMenu.currentState else {
        return
      }
      self?.delegate?.reviewWritingThemeCell(self, isSelected: currentState == .selected)
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    configure(themeText: nil, isSelected: false)
  }
  
  // MARK: - Helpers
  func configure(themeText: String?, isSelected: Bool) {
    guard let themeText else {
      themeMenu.setTitle(nil, for: .normal)
      themeMenu.currentState = .normal
      return
    }
    themeMenu.setTitle(themeText, for: .normal)
    themeMenu.currentState = isSelected ? .selected : .normal
  }
}

// MARK: - LayoutSupport
extension ReviewWritingThemeCell: LayoutSupport {
  func addSubviews() {
    contentView.addSubview(themeMenu)
  }
  
  func setConstraints() {
    themeMenu.autoresizingMask = [
      .flexibleLeftMargin,
      .flexibleTopMargin,
      .flexibleRightMargin,
      .flexibleBottomMargin]
  }
}
