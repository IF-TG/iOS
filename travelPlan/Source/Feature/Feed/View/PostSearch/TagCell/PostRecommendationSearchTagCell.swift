//
//  PostRecommendationSearchTagCell.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/05/10.
//

import UIKit
import SnapKit

class PostRecommendationSearchTagCell: UICollectionViewCell {
  // MARK: - Properties
  class var id: String {
    return String(describing: self)
  }
  
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
extension PostRecommendationSearchTagCell {
  private func setupStyles() {
    contentView.backgroundColor = .yg.primary.withAlphaComponent(Constants.ContentView.alphaComponent)
    contentView.layer.borderColor = UIColor.YG.gray0.cgColor
    contentView.layer.borderWidth = Constants.ContentView.borderWidth
    contentView.layer.cornerRadius = Constants.ContentView.cornerRadius
  }
}

// MARK: - Public Helpers
extension PostRecommendationSearchTagCell {
  func configure(_ text: String) {
    tagLabel.text = text
  }
}

// MARK: - LayoutSupport
extension PostRecommendationSearchTagCell: LayoutSupport {
  func addSubviews() {
    contentView.addSubview(tagLabel)
  }
  
  func setConstraints() {
    tagLabel.snp.makeConstraints {
      $0.trailing.equalToSuperview().inset(Constants.TagLabel.Inset.trailing)
      $0.leading.equalToSuperview().inset(Constants.TagLabel.Inset.leading)
      $0.top.equalToSuperview().inset(Constants.TagLabel.Inset.top)
      $0.bottom.equalToSuperview().inset(Constants.TagLabel.Inset.bottom)
    }
  }
}
