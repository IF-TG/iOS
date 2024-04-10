//
//  PostDetailCategoryCell.swift
//  travelPlan
//
//  Created by 양승현 on 4/8/24.
//

import UIKit

/// 포스트 상세화면 -> 상세 카테고리
class PostDetailCategoryCell: UITableViewCell {
  // MARK: - Properties
  
  @IBOutlet weak var categoryLabel: BaseLabel!
  
  // MARK: - Lifecycle
  override func prepareForReuse() {
    super.prepareForReuse()
    categoryLabel.text = nil
  }
  
  // MARK: - Helpers
  func configure(with categoryText: String?) {
    guard let categoryText else {
      categoryLabel.text = nil
      return
    }
    categoryLabel.text = categoryText
    let highlightFontInfo = HighlightFontInfo(
      fontType: .semiBold_600(fontSize: 15),
      lineHeight: 18,
      text: ">",
      additionalAttributes: [.foregroundColor: UIColor.yg.gray2])
    categoryLabel.setHighlight(with: highlightFontInfo)
  }
}
