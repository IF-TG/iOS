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
  private let themeMenu = PrimaryColorToneRoundLabel(currentState: .normal)
  
  weak var delegate: ReviewWritingThemeCellDelegate?
  
  private var isEnableMultiSelection: Bool = false
  
  // MARK: - Lifecycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
    bind()
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
      themeMenu.text = nil
      themeMenu.isSelected = false
      return
    }
    themeMenu.text = themeText
    themeMenu.isSelected = isSelected
  }
  
  func activeSelection() {
    themeMenu.isSelected = false
    themeMenu.isUserInteractionEnabled = true
  }
  
  func deactiveSelection() {
    themeMenu.isSelected = true
    themeMenu.isUserInteractionEnabled = false
  }
  
  // MARK: - Private Helpers
  func bind() {
    themeMenu.tapHandler = { [weak self] in
      guard
        let isSelected = self?.themeMenu.isSelected,
        let isEnableMultiSelection = self?.isEnableMultiSelection
      else { return }
      
      if !isEnableMultiSelection {
        self?.themeMenu.isUserInteractionEnabled = !isSelected
      }
      self?.delegate?.reviewWritingThemeCell(self, isSelected: isSelected)
    }

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
