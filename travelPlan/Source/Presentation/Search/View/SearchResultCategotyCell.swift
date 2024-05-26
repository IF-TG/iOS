//
//  SearchResultCategotyCell.swift
//  travelPlan
//
//  Created by SeokHyun on 5/25/24.
//

import UIKit
import SnapKit

final class SearchResultCategotyCell: UICollectionViewCell {
  // MARK: - Properties
  static let id = String(describing: SearchResultCategotyCell.self)
  
  private let tagLabel = PostSearchTagLabel().set {
    $0.textColor = UIColor.YG.highlight
  }
  
  // MARK: - LifeCycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Helpers
extension SearchResultCategotyCell {
  func configure(with textString: String) {
    tagLabel.text = textString
  }
}

// MARK: - LayoutSupport
extension SearchResultCategotyCell: LayoutSupport {
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
