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
  static var id: String {
    return String(describing: SearchResultCategoryCell.self)
  }
  
  private let tagLabel = SearchHistoryTagLabel().set {
    $0.textColor = UIColor.YG.highlight
  }
  
  private(set) var contentTypeId: Int?
  
  override var isSelected: Bool {
    didSet {
      isSelected ? selectedUI() : unselectedUI()
    }
  }
  
  // MARK: - LifeCycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
    unselectedUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Helpers
extension SearchResultCategoryCell {
  func configure(with info: TravelDestinationCategoryInfo) {
    tagLabel.text = info.title
    contentTypeId = info.contentTypeId
    contentView.layer.cornerRadius = min(contentView.frame.width, contentView.frame.height) / 2
  }
}

// MARK: - Private Helpers
extension SearchResultCategoryCell {
  private func selectedUI() {
    contentView.backgroundColor = .yg.primary.withAlphaComponent(0.15)
    contentView.layer.borderColor = UIColor.yg.highlight.cgColor
    contentView.layer.borderWidth = 1.5
    tagLabel.textColor = .yg.highlight
  }
  
  private func unselectedUI() {
    contentView.backgroundColor = .yg.littleWhite
    contentView.layer.borderColor = UIColor.yg.gray0.cgColor
    contentView.layer.borderWidth = 1
    tagLabel.textColor = .yg.gray4
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

/*
 현재 cell 클릭 여부에 따라서 내부 ui color 변경
 */
