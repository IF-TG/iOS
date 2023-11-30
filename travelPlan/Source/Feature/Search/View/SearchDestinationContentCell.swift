//
//  SearchDestinationContentCell.swift
//  travelPlan
//
//  Created by SeokHyun on 11/30/23.
//

import UIKit
import SnapKit

struct SearchDestinationContentInfo {
  let title: String?
  let description: String?
}

final class SearchDestinationContentCell: UICollectionViewCell {
  // MARK: - Properties
  static let id = String(describing: SearchDestinationContentCell.self)
  
  private let titleLabel = UILabel().set {
    $0.text = "제목"
    $0.font = .init(pretendard: .semiBold_600(fontSize: 16))
    $0.textColor = .yg.gray6
  }
  
  private let descriptionLabel = UILabel().set {
    $0.text = "부가설명"
    $0.font = .init(pretendard: .regular_400(fontSize: 14))
    $0.textColor = .yg.gray5
    $0.numberOfLines = 0
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

// MARK: - LayoutSupport
extension SearchDestinationContentCell: LayoutSupport {
  func addSubviews() {
    contentView.addSubview(titleLabel)
    contentView.addSubview(descriptionLabel)
  }
  
  func setConstraints() {
    titleLabel.snp.makeConstraints {
      $0.leading.top.equalToSuperview()
      $0.trailing.lessThanOrEqualToSuperview()
    }
    
    descriptionLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(10)
      $0.leading.equalTo(titleLabel)
      $0.trailing.equalTo(titleLabel)
      $0.bottom.equalToSuperview()
    }
  }
}

// MARK: - Helpers
extension SearchDestinationContentCell {
  func configure(with model: SearchDestinationContentInfo) {
    titleLabel.text = model.title
    descriptionLabel.text = model.description
  }
}
