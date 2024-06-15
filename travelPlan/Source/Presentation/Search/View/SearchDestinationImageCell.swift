//
//  SearchDestinationImageCell.swift
//  travelPlan
//
//  Created by SeokHyun on 6/12/24.
//

import UIKit
import SnapKit

final class SearchDestinationImageCell: UICollectionViewCell {
  // MARK: - Properties
  private let thumbnailImageView = UIImageView().set {
    $0.backgroundColor = .yg.littleWhite
    $0.contentMode = .scaleAspectFill
    $0.clipsToBounds = true
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
extension SearchDestinationImageCell {
  func configure(with data: Data) {
    thumbnailImageView.image = UIImage(data: data)
  }
}

// MARK: - LayoutSupport
extension SearchDestinationImageCell: LayoutSupport {
  func addSubviews() {
    contentView.addSubview(thumbnailImageView)
  }
  
  func setConstraints() {
    thumbnailImageView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
}
