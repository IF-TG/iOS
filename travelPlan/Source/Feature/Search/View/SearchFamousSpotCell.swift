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
  private var viewModel: SearchFamousSpotCellViewModel?
  
  static var id: String {
    return String(describing: self)
  }
  
  weak var buttonDelegate: HeartButtonDelegate?
  
  private let thumbnailImageView: UIImageView = UIImageView().set {
    $0.image = UIImage(named: Constants.ThumbnailImageView.imageName)
    $0.layer.cornerRadius = Constants.ThumbnailImageView.cornerRadius
    $0.contentMode = .scaleAspectFill
    $0.layer.masksToBounds = true
  }
  
  private lazy var heartButton: UIButton = UIButton().set {
    $0.setImage(UIImage(named: Constants.HeartButton.normalImageName), for: .normal)
    $0.setImage(UIImage(named: Constants.HeartButton.selectedImageName), for: .selected)
    $0.addTarget(self, action: #selector(didTapHeartButton), for: .touchUpInside)
  }
  
  private let placeLabel: UILabel = UILabel().set {
    $0.font = .init(pretendard: .semiBold, size: Constants.PlaceLabel.fontSize)
    $0.text = "관광 장소명"
    $0.textColor = .yg.gray6
    $0.numberOfLines = Constants.PlaceLabel.numberOfLines
  }
  
  private let categoryLabel: UILabel = UILabel().set {
    $0.font = .init(pretendard: .medium, size: Constants.CategoryLabel.fontSize)
    $0.textColor = .yg.gray6
    $0.text = "관광 카테고리"
    $0.numberOfLines = Constants.CategoryLabel.numberOfLines
  }
  
  private let areaLabel: UILabel = UILabel().set {
    $0.font = .init(pretendard: .medium, size: Constants.AreaLabel.size)
    $0.text = "지역명"
    $0.textColor = .yg.gray6
    $0.numberOfLines = Constants.AreaLabel.numberOfLines
  }
  
  private let labelStackView: UIStackView = UIStackView().set {
    $0.axis = .vertical
    $0.spacing = Constants.LabelStackView.spacing
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

// MARK: - Actions
extension SearchFamousSpotCell {
  @objc private func didTapHeartButton() {
    buttonDelegate?.didTapHeartButton()
    print("DEBUG: 버튼 변화됨!")
  }
}

// MARK: - Configure
extension SearchFamousSpotCell {
  func configure(viewModel: SearchFamousSpotCellViewModel) {
    thumbnailImageView.image = UIImage(named: viewModel.thumbnailImage ?? "tempProfile4")
    placeLabel.text = viewModel.place
    categoryLabel.text = viewModel.category
    areaLabel.text = viewModel.location
    
    self.viewModel = viewModel
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
      $0.leading.equalToSuperview()
        .inset(Constants.ThumbnailImageView.Inset.leading)
      $0.top.equalToSuperview()
      $0.bottom.equalToSuperview()
      $0.width.equalTo(thumbnailImageView.snp.height)
    }
    
    labelStackView.snp.makeConstraints {
      $0.leading.equalTo(thumbnailImageView.snp.trailing)
        .offset(Constants.LabelStackView.Offset.leading)
      $0.trailing.lessThanOrEqualTo(heartButton.snp.leading)
        .offset(Constants.LabelStackView.Offset.trailing)
      $0.top.equalTo(thumbnailImageView)
    }
    
    heartButton.snp.makeConstraints {
      $0.top.equalToSuperview().inset(Constants.HeartButton.Inset.top)
      $0.trailing.equalToSuperview()
        .inset(Constants.HeartButton.Inset.trailing)
      $0.size.equalTo(Constants.HeartButton.size)
    }
  }
}
