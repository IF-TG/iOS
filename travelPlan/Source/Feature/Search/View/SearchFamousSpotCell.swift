//
//  SearchFamousSpotCell.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/06/01.
//

import UIKit
import SnapKit

final class SearchFamousSpotCell: UICollectionViewCell {
  // MARK: - Properties
  static var id: String {
    return String(describing: self)
  }
  
  private let thumbnailImageView: UIImageView = UIImageView().set {
    $0.image = UIImage(named: "tempThumbnail1")
    $0.layer.cornerRadius = 3
    $0.contentMode = .scaleAspectFill
    $0.layer.masksToBounds = true
  }
  
  private let heartButton: UIButton = UIButton().set {
    $0.setImage(UIImage(named: "selectedHeart"), for: .normal)
  }
  
  private let placeLabel: UILabel = UILabel().set {
    $0.font = .init(pretendard: .semiBold, size: 16)
    $0.text = "관광 장소명" // will erase
    $0.textColor = .yg.gray6
    $0.numberOfLines = 1
  }
  
  private let categoryLabel: UILabel = UILabel().set {
    $0.font = .init(pretendard: .medium, size: 14)
    $0.textColor = .yg.gray6
    $0.text = "관광 카테고리"
    $0.numberOfLines = 1
  }
  
  private let areaLabel: UILabel = UILabel().set {
    $0.font = .init(pretendard: .medium, size: 14)
    $0.text = "지역명" // will erase
    $0.textColor = .yg.gray6
    $0.numberOfLines = 1
  }
  
  private let labelStackView: UIStackView = UIStackView().set {
    $0.axis = .vertical
    $0.spacing = 0
    $0.alignment = .leading
  }
  
  // MARK: - LifeCycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    thumbnailImageView.image = nil
  }
}

// MARK: - Configure
extension SearchFamousSpotCell {
  func configure(_ item: FamousSpotItem) {
    thumbnailImageView.image = UIImage(named: item.imageName ?? "FamousSpotItem")
    placeLabel.text = item.title
    categoryLabel.text = item.catrgory
    areaLabel.text = item.area
  }
}

// MARK: - LayoutSupport
extension SearchFamousSpotCell: LayoutSupport {
  func addSubviews() {
    contentView.addSubview(thumbnailImageView)
    contentView.addSubview(labelStackView)
    contentView.addSubview(heartButton)
    _ = [placeLabel, categoryLabel, areaLabel]
      .map { labelStackView.addArrangedSubview($0) }
  }
  
  func setConstraints() {
    thumbnailImageView.snp.makeConstraints {
      $0.leading.equalToSuperview().inset(20)
      $0.top.equalToSuperview()
      $0.bottom.equalToSuperview()
      $0.width.equalTo(thumbnailImageView.snp.height)
    }
    
    labelStackView.snp.makeConstraints {
      $0.leading.equalTo(thumbnailImageView.snp.trailing).offset(15)
      $0.trailing.lessThanOrEqualTo(heartButton.snp.leading).offset(-10)
      $0.top.equalTo(thumbnailImageView)
    }
    
    heartButton.snp.makeConstraints {
      $0.top.equalToSuperview().inset(5)
      $0.trailing.equalToSuperview().inset(10)
      $0.size.equalTo(20)
    }
  }
}
