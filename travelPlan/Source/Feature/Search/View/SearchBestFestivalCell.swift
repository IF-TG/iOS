//
//  SearchBestFestivalCell.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/05/30.
//

import UIKit
import SnapKit

final class SearchBestFestivalCell: UICollectionViewCell {
  // MARK: - Properties
  static var id: String {
    return String(describing: self)
  }
  
  private let thumbnailImageView: UIImageView = .init().set {
    $0.layer.cornerRadius = 3
    $0.contentMode = .scaleAspectFill
    $0.layer.masksToBounds = true
    $0.isUserInteractionEnabled = true // UIImageView의 터치 이벤트를 감지하기 위해 인터랙션을 활성화
  }
  
  private lazy var heartButton: UIButton = .init().set {
    $0.setImage(UIImage(named: "unselectedHeart"), for: .normal)
    $0.setImage(UIImage(named: "selectedHeart"), for: .selected)
    $0.addTarget(self, action: #selector(didTapHeartButton), for: .touchUpInside)
  }
  weak var buttonDelegate: HeartButtonDelegate?
  
  private let festivalLabel: UILabel = .init().set {
    $0.font = UIFont(pretendard: .bold, size: 18)
    $0.textColor = .yg.gray00Background
    $0.numberOfLines = 1
    $0.textAlignment = .center
    
    $0.text = "축제명축제명축제명"
  }
  
  private let dateLabel: UILabel = .init().set {
    $0.font = UIFont(pretendard: .semiBold, size: 12)
    $0.textColor = .yg.gray00Background
    $0.textAlignment = .center
    
    $0.text = "2023.12.30~2023.12.31"
    // shadowTODO: - shadow, blur 처리
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
  
  override func prepareForReuse() {
    super.prepareForReuse()
    thumbnailImageView.image = nil
  }
}

// MARK: - Actions
extension SearchBestFestivalCell {
  @objc private func didTapHeartButton() {
    buttonDelegate?.didTapHeartButton()
    heartButton.isSelected.toggle()
  }
}

// MARK: - Helpers
extension SearchBestFestivalCell {
  private func setupStyles() {
    contentView.backgroundColor = .systemBlue
  }
}

// MARK: - Configure
extension SearchBestFestivalCell {
  func configure(_ item: FestivalItem) {
    festivalLabel.text = item.title
    dateLabel.text = item.date
    // imageTODO: - 이미지 적용
    thumbnailImageView.image = UIImage(named: item.imageName ?? "tempThumbnail15")
  }
}

// MARK: - LayoutSupport
extension SearchBestFestivalCell: LayoutSupport {
  func addSubviews() {
    contentView.addSubview(thumbnailImageView)
    thumbnailImageView.addSubview(heartButton)
    thumbnailImageView.addSubview(festivalLabel)
    thumbnailImageView.addSubview(dateLabel)
  }
  
  func setConstraints() {
    thumbnailImageView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    heartButton.snp.makeConstraints {
      $0.top.equalToSuperview().inset(8)
      $0.right.equalToSuperview().inset(8)
      $0.size.equalTo(20)
    }
    
    festivalLabel.snp.makeConstraints {
      $0.leading.equalToSuperview().inset(4)
      $0.trailing.lessThanOrEqualToSuperview().inset(4)
    }
    
    dateLabel.snp.makeConstraints {
      $0.top.equalTo(festivalLabel.snp.bottom)
      $0.leading.equalTo(4)
      $0.trailing.lessThanOrEqualToSuperview().inset(4)
      $0.bottom.equalToSuperview().inset(6)
    }
  }
}
