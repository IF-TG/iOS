//
//  SearchDestinationTitleCell.swift
//  travelPlan
//
//  Created by SeokHyun on 11/28/23.
//

import UIKit
import SnapKit

final class SearchDestinationTitleCell: UICollectionViewCell {
  // MARK: - Properties
  static let id = String.init(describing: SearchDestinationTitleCell.self)
  
  private let titleLabel = UILabel().set {
    $0.textColor = .yg.gray7
    $0.font = .init(pretendard: .medium_500(fontSize: 22))
    $0.text = "타이틀타이틀타이틀타이틀타이틀타이틀타이틀타이틀타이틀타이틀타이틀타이틀타이틀"
    $0.numberOfLines = 0
  }

  private let addressLabel = UILabel().set {
    $0.text = "주주소주주소주주소주주소주주소주주소주주소주주소주주소주주소주주소"
    $0.font = .init(pretendard: .regular_400(fontSize: 12))
    $0.textColor = .yg.gray6
  }
  
  private let mapImageView = UIImageView(image: .init(named: "marker-pin"))
  
  private let toggleButton = UIButton().set {
    $0.setImage(.init(named: "chevron"), for: .normal)
    $0.imageView?.tintColor = .yg.gray6
  }
  
  private let copyAddressButton = UIButton().set {
    $0.setTitle("복사", for: .normal)
    $0.setTitleColor(.yg.highlight, for: .normal)
    $0.titleLabel?.font = .init(pretendard: .medium_500(fontSize: 13))
  }
  
  private let unselectedHeartButton = UIButton().set {
    $0.setImage(.init(named: "unselectedHeart"), for: .normal)
  }
  
  private let heartCountLabel = UILabel().set {
    $0.text = "+1"
    $0.textColor = .yg.gray6
    $0.font = .init(pretendard: .regular_400(fontSize: 11))
  }
  
  private let heartStackView = UIStackView().set {
    $0.axis = .horizontal
    $0.alignment = .center
  }
  
  // MARK: - LifeCycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
    contentView.backgroundColor = .systemRed.withAlphaComponent(0.3)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - LayoutSupport
extension SearchDestinationTitleCell: LayoutSupport {
  func addSubviews() {
    contentView.addSubview(titleLabel)
    contentView.addSubview(mapImageView)
    contentView.addSubview(addressLabel)
    contentView.addSubview(toggleButton) // dynamic add
    contentView.addSubview(copyAddressButton)
    contentView.addSubview(heartStackView)
    [unselectedHeartButton,
     heartCountLabel]
      .forEach { heartStackView.addArrangedSubview($0) }
    addressLabel.setContentCompressionResistancePriority(.fittingSizeLevel, for: .horizontal)
    titleLabel.setContentCompressionResistancePriority(.fittingSizeLevel, for: .horizontal)
  }
  
  func setConstraints() {
    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().inset(20)
      $0.leading.equalToSuperview().inset(16)
      $0.trailing.equalTo(heartStackView.snp.leading).offset(-41)
    }
    
    mapImageView.snp.makeConstraints {
      $0.leading.equalToSuperview().inset(16)
      $0.top.equalTo(titleLabel.snp.bottom).offset(10)
    }
    
    addressLabel.snp.makeConstraints {
      $0.leading.equalTo(mapImageView.snp.trailing).offset(2)
      $0.centerY.equalTo(mapImageView)
    }
    
    copyAddressButton.snp.makeConstraints {
      $0.leading.equalTo(addressLabel.snp.trailing).offset(2)
      $0.trailing.lessThanOrEqualTo(heartStackView.snp.leading).offset(-41)
      $0.centerY.equalTo(mapImageView)
    }
    
    heartStackView.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.trailing.equalToSuperview().inset(16)
    }
  }
}
