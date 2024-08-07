//
//  DestinationDetailImageCell.swift
//  travelPlan
//
//  Created by SeokHyun on 6/12/24.
//

import UIKit
import SnapKit

final class DestinationDetailImageCell: UICollectionViewCell {
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
extension DestinationDetailImageCell {
  func configure(with data: Data?) {
    if let data = data {
      thumbnailImageView.image = UIImage(data: data)
    } else {
      // TODO: - Data가 없는 경우, Default 이미지를 추가해야 합니다.
      thumbnailImageView.image = UIImage(named: "emptyImageSquare")
    }
  }
}

// MARK: - LayoutSupport
extension DestinationDetailImageCell: LayoutSupport {
  func addSubviews() {
    contentView.addSubview(thumbnailImageView)
  }
  
  func setConstraints() {
    thumbnailImageView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
}
