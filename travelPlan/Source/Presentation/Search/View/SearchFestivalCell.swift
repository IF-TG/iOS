//
//  SearchFestivalCell.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/05/30.
//

import Combine
import UIKit

import SnapKit

final class SearchFestivalCell: UICollectionViewCell {
  // MARK: - Properties
  private lazy var thumbnailImageView: UIImageView = .init().set {
    $0.contentMode = .scaleAspectFill
    $0.layer.masksToBounds = true
    $0.isUserInteractionEnabled = true // UIImageView의 터치 이벤트를 감지하기 위해 인터랙션을 활성화
    $0.layer.cornerRadius = 7
    $0.layer.insertSublayer(self.thumbnailGradientLayer, at: .zero)
  }
  
  private let thumbnailGradientLayer: CAGradientLayer = .init().set {
    $0.colors = [
      UIColor.clear.cgColor,
      UIColor.yg.gray7.withAlphaComponent(1.0).cgColor
    ]
    $0.locations = [0.7, 1.0]
  }
  
  private let starButton: SearchStarButton = .init(normalType: .white)
  
  private let titleLabel: UILabel = .init().set {
    $0.font = UIFont(pretendard: .bold_700(fontSize: 18))
    $0.textColor = .yg.littleWhite
    $0.numberOfLines = 1
    $0.textAlignment = .center
    $0.text = "축제명"
  }
  
  private let locationLabel: UILabel = .init().set {
    $0.font = UIFont(pretendard: .semiBold_600(fontSize: 12))
    $0.textColor = .yg.littleWhite
    $0.textAlignment = .center
    $0.text = "장소"
  }
  
  override var bounds: CGRect {
    didSet {
      self.thumbnailGradientLayer.frame = self.bounds
    }
  }
  
  private var cancellable: AnyCancellable?
  
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
    locationLabel.text = nil
    titleLabel.text = nil
    starButton.isSelected = false
  }
}

// MARK: - Configure
extension SearchFestivalCell {
  func configure(with info: TravelDestinationInfo) {
    titleLabel.text = info.place
    locationLabel.text = info.location
    starButton.isSelected = info.isButtonSelected
    
    // imageTODO: - 이미지 적용
    if let imageData = info.imageData {
      thumbnailImageView.image = UIImage(data: imageData)
    } else {
      thumbnailImageView.image = UIImage(named: "tempThumbnail7")
    }
  }
  
  func bind(to publisher: PassthroughSubject<(IndexPath, Bool), Never>, indexPath: IndexPath) {
    cancellable?.cancel()
    cancellable = starButton
      .tap
      .receive(on: RunLoop.main)
      .sink { [weak self] _ in
        guard let self = self else { return }
        publisher.send((indexPath, self.starButton.isSelected))
      }
  }
}

// MARK: - LayoutSupport
extension SearchFestivalCell: LayoutSupport {
  func addSubviews() {
    thumbnailImageView.layer.insertSublayer(thumbnailGradientLayer, at: .zero)
    
    contentView.addSubview(thumbnailImageView)
    thumbnailImageView.addSubview(starButton)
    thumbnailImageView.addSubview(titleLabel)
    thumbnailImageView.addSubview(locationLabel)
  }
  
  func setConstraints() {
    thumbnailImageView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    starButton.snp.makeConstraints {
      $0.top.equalToSuperview().inset(8)
      $0.trailing.equalToSuperview().inset(8)
      $0.size.equalTo(24)
    }
    
    titleLabel.snp.makeConstraints {
      $0.leading.equalToSuperview().inset(4)
      $0.trailing.lessThanOrEqualToSuperview().inset(4)
    }
    
    locationLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom)
      $0.leading.equalTo(titleLabel)
      $0.trailing.lessThanOrEqualToSuperview()
        .inset(4)
      $0.bottom.equalToSuperview()
        .inset(6)
    }
  }
}
