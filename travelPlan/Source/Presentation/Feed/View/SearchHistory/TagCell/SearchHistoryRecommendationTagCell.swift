//
//  SearchHistoryRecommendationTagCell.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/05/10.
//

import UIKit
import SnapKit

class SearchHistoryRecommendationTagCell: UICollectionViewCell {
  enum Constants {
    enum ContentView {
      static let borderWidth: CGFloat = 1
      static let alphaComponent: CGFloat = 0.1
    }
    
    enum TagLabel {
      enum Inset {
        static let trailing: CGFloat = 13
        static let leading: CGFloat = 13
        static let top: CGFloat = 4
        static let bottom: CGFloat = 4
      }
    }
  }
  
  // MARK: - Properties
  class var id: String {
    return String(describing: self)
  }
  
  private let tagLabel = SearchHistoryTagLabel().set {
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
extension SearchHistoryRecommendationTagCell {
  private func setupStyles() {
    contentView.backgroundColor = .yg.primary.withAlphaComponent(Constants.ContentView.alphaComponent)
    contentView.layer.borderColor = UIColor.YG.gray0.cgColor
    contentView.layer.borderWidth = Constants.ContentView.borderWidth
  }
}

// MARK: - Public Helpers
extension SearchHistoryRecommendationTagCell {
  func configure(_ text: String) {
    tagLabel.text = text
    contentView.layer.cornerRadius = min(contentView.frame.width, contentView.frame.height) / 2
  }
}

// MARK: - LayoutSupport
extension SearchHistoryRecommendationTagCell: LayoutSupport {
  func addSubviews() {
    contentView.addSubview(tagLabel)
  }
  
  func setConstraints() {
    tagLabel.snp.makeConstraints {
      typealias Inset = Constants.TagLabel.Inset
      $0.trailing.equalToSuperview().inset(Inset.trailing)
      $0.leading.equalToSuperview().inset(Inset.leading)
      $0.top.equalToSuperview().inset(Inset.top)
      $0.bottom.equalToSuperview().inset(Inset.bottom)
    }
  }
}
