//
//  SearchResultCategoryCell.swift
//  travelPlan
//
//  Created by SeokHyun on 5/25/24.
//

import UIKit
import SnapKit

final class SearchResultCategoryCell: UICollectionViewCell {
  // MARK: - Properties
  static let id = String(describing: SearchResultCategoryCell.self)
  
  private let tagLabel = PostSearchTagLabel().set {
    $0.textColor = UIColor.YG.highlight
  }
  
  // MARK: - LifeCycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
    setupStyles()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Helpers
extension SearchResultCategoryCell {
  func configure(with textString: String) {
    tagLabel.text = textString
    contentView.layer.cornerRadius = min(contentView.frame.width, contentView.frame.height) / 2
  }
}

// MARK: - Private Helpers
extension SearchResultCategoryCell {
  private func setupStyles() {
    contentView.backgroundColor = .yg.veryLightGray
    contentView.layer.borderColor = UIColor.YG.gray0.cgColor
    contentView.layer.borderWidth = 1
  }
}

// MARK: - LayoutSupport
extension SearchResultCategoryCell: LayoutSupport {
  func addSubviews() {
    contentView.addSubview(tagLabel)
  }
  
  func setConstraints() {
    tagLabel.snp.makeConstraints {
      $0.trailing.equalToSuperview().inset(13)
      $0.leading.equalToSuperview().inset(13)
      $0.top.equalToSuperview().inset(4)
      $0.bottom.equalToSuperview().inset(4)
    }
  }
}
